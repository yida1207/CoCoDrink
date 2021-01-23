//
//  MenuController.swift
//  CoCoDrink
//
//  Created by Yida on 2020/11/29.
//  Copyright © 2020 Yida. All rights reserved.
//

import Foundation
import UIKit

class MenuController{
    static let shared = MenuController()
    static var segueId:String!
       
    let baseURL = URL(string: "https://sheetdb.io/api/v1/4pvwa1g4ucsxx")!
//    let baseURL = URL(string: "https://sheetdb.io/api/v1/1fiss7his5axo")!
        
    func fetchMenu( completion: @escaping ([Menu]?) -> Void){
        let url = Bundle.main.url(forResource: "CoCoMenu", withExtension: "plist")!
        if let data = try? Data(contentsOf: url), let menu = try? PropertyListDecoder().decode([Menu].self, from: data){
            completion(menu)
        }
    }
    
    func fetchOrder(completion: @escaping ([OrderItem]?) -> Void){
        URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            if let data = data, let orderItem = try? JSONDecoder().decode([OrderItem].self, from: data){
                completion(orderItem)
            }
        }.resume()
    }
    
    func submitOrder(orderItem:[OrderItem] ,completion: @escaping (Bool) -> Void){
        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let order = Order(data: orderItem)        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(order){
            urlRequest.httpBody = data
            
            URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try? decoder.decode([String:Int].self, from: retData), dic["created"] == 1{
                    completion(true)
                }else{
                    completion(false)
                }
            }.resume()
        }
    }
    
    func modifyOrder(orderItem:[OrderItem] ,completion: @escaping (Bool) -> Void){
        let baseURL = URL(string: "https://sheetdb.io/api/v1/4pvwa1g4ucsxx" + "/orderNo/" + orderItem[0].orderNo)!
//        let baseURL = URL(string: "https://sheetdb.io/api/v1/1fiss7his5axo" + "/orderNo/" + orderItem[0].orderNo)!
        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let order = Order(data: orderItem)        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(order){
            urlRequest.httpBody = data
            
            URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try? decoder.decode([String:Int].self, from: retData){
                    completion(true)
                }else{
                    completion(false)
                }
            }.resume()
        }
    }
    
    func deleteOrder(orderItem:OrderItem ,completion: @escaping (Bool) -> Void){
        let baseURL = URL(string: "https://sheetdb.io/api/v1/4pvwa1g4ucsxx" + "/orderNo/" + orderItem.orderNo)!
//        let baseURL = URL(string: "https://sheetdb.io/api/v1/1fiss7his5axo" + "/orderNo/" + orderItem.orderNo)!
        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try? decoder.decode([String:Int].self, from: retData){
                completion(true)
            }else{
                completion(false)
            }
        }.resume()
    }
        
}

