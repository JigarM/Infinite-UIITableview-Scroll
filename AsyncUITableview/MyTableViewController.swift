//
//  MyTableViewController.swift
//  AsyncUITableview
//
//  Created by Jigar M on 03/08/14.
//  Copyright (c) 2014 Jigar M. All rights reserved.
//

import UIKit
import Foundation

class MyTableViewController: UITableViewController {
    
    let PageSize = 20
    var items:MyItem[] = []
    var isLoading = false
    @IBOutlet var MyFooterView : UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSegment(0, size: 20)
    }
    
    func getRandomNumberBetween (From: Int , To: Int) -> Int {
        return From + Int(arc4random_uniform(UInt32(To - From + 1)))
    }
    
    class MyItem : Printable {
        let name:String!
        
        init(name:String) {
            self.name = name
        }
        
        var description: String {
            return name
        }
    }
    
    class DataManager {
        func requestData(offset:Int, size:Int, listener:(MyItem[]) -> ()) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                //Sleep the Process
                if offset != 0 {
                    sleep(2)
                }
                
                //generate items
                var arr:MyItem[] = []
                for i in offset...(offset + size) {
                    arr += MyItem(name: "Item " + String(i))
                }
                
                println(arr)
                
                //call listener in main thread
                dispatch_async(dispatch_get_main_queue()) {
                    listener(arr)
                }
            }
        }
    }
    
    func loadSegment(offset:Int, size:Int) {
        if (!self.isLoading) {
            self.isLoading = true
            self.MyFooterView.hidden = (offset==0) ? true : false
            
            let manager = DataManager()
            manager.requestData(offset, size: size,
                listener: {(items:MyTableViewController.MyItem[]) -> () in
                    
                    /*
                    //You can also Reload all the Data using below code.
                    //But this one is the not good option.
                    //Instead of Reloading Table data, you can add 20 rows when table scroll is at end positoon
                    
                    for item in items {
                        self.items += item
                    }
                    self.tableView.reloadData()
                    self.isLoading = false
                    self.MyFooterView.hidden = true
                    
                    */
                    
                    
                    /*
                    Add Rows at indexpath
                    */
                    for item in items {
                        var row = self.items.count
                        var indexPath = NSIndexPath(forRow:row,inSection:0)
                        self.items += item
                        self.tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                    self.isLoading = false
                    self.MyFooterView.hidden = true
                }
            )
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView!) {
        var offset = scrollView.contentOffset.y
        var maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 40 {
            loadSegment(items.count, size: PageSize-1)
        }
    }
    
    // #pragma mark - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 85;
    }
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        let cell : MyTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as MyTableViewCell

        //Configure the cell...
        var imagename = UTILITY.getRandomNumberBetween(1, To: 10).description + ".png"
        cell.img.image = UIImage(named:imagename) as UIImage
        cell.lbl.text = items[indexPath.row].name as String
        return cell
    }
}
