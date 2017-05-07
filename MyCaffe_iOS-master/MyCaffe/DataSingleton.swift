//
//  DataSingleton.swift
//  MyCaffe
//
//  Created by YoungKwangLee on 2016. 8. 24..
//  Copyright © 2016년 YoungKwangLee. All rights reserved.
//

import Foundation

class DataSingleton {
    
    private static var __once: () = {
            Static.instance = DataSingleton()
        }()
    
    class var sharedInstance: DataSingleton {
        struct Static {
            static var instance: DataSingleton?
            static var token: Int = 0
        }
        
        _ = DataSingleton.__once
        
        return Static.instance!
    }
    
    var isCafeSelectedPop: Bool!
    var cafeIDX: Int!
    var cafeName: String!
    
}
