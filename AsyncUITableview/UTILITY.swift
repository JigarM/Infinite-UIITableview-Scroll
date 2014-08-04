//
//  UTILITY.swift
//  AsyncUITableview
//
//  Created by Jigar M on 04/08/14.
//  Copyright (c) 2014 Jigar M. All rights reserved.
//

import UIKit

class UTILITY: NSObject {
   
    class func getRandomNumberBetween (From: Int , To: Int) -> Int {
        return From + Int(arc4random_uniform(UInt32(To - From + 1)))
    }
    
}
