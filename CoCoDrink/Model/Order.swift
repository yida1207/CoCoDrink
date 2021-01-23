//
//  Order.swift
//  CoCoDrink
//
//  Created by Yida on 2020/11/29.
//  Copyright © 2020 Yida. All rights reserved.
//

import Foundation

struct OrderItem:Codable{
    var orderNo:String
    var name:String
    var drink:String
    var sugar:String
    var ice:String
    var price:String
    var orderDate:String
}

struct Order:Codable{
    let data:[OrderItem]
}
