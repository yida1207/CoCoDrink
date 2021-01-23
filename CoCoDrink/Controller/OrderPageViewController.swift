//
//  OrderPageViewController.swift
//  CoCoDrink
//
//  Created by Yida on 2020/12/5.
//  Copyright © 2020 Yida. All rights reserved.
//

import UIKit

class OrderPageViewController: UIViewController ,UITextFieldDelegate{
    
    var menu:Menu!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sendOrderButton: UIButton!
    var sugar = "正常糖"
    var ice = "正常冰"
    var orderNo = ""
    var orderItem = [OrderItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        //尚未輸入時的預設顯示提示文字
        nameTextField.placeholder = "請輸入名字"
        //輸入框右邊顯示清除按鈕時機
        nameTextField.clearButtonMode = .whileEditing
        
        sendOrderButton.layer.cornerRadius = 5.0
        drinkLabel.text = menu.name
        priceLabel.text = "$" + String(menu.price)
        let image = UIImage(named: menu.name)
        drinkImageView.image = image
    }
    
    @IBAction func sugarClick(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        sugar = sender.titleForSegment(at: index)!
    }
   
    @IBAction func iceClick(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        ice = sender.titleForSegment(at: index)!
    }
    //點return收鍵盤
    func textFieldShouldReturn(_ textField:UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    //點空白處收鍵盤
    override func touchesBegan(_ touches:Set<UITouch>, with event:UIEvent?){
        self.view.endEditing(true)
    }
    
    func noName(){
        let alertController = UIAlertController(title: "提示", message: "名字尚未輸入", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "確定", style: .default) { (action) in
//            print("按下確定")
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func sendOrder(_ sender: Any) {
        
        guard nameTextField != nil else {
             let alertController = UIAlertController(title: "提示", message: "沒有名稱欄位 請聯絡工程師", preferredStyle: .alert)
             let okAction = UIAlertAction(title: "確定", style: .default) { (action) in
             }
             alertController.addAction(okAction)
             present(alertController, animated: true, completion: nil)
             return
        }
        
        guard nameTextField.text != nil else{
            noName()
            return
        }
        guard !(nameTextField.text?.isEmpty)! else{
            noName()
            return
        }
        
        guard let strName = nameTextField.text?.trimmingCharacters(in: .whitespaces) else{
            return
        }
        
        guard strName != "" else {
            noName()
            return
        }
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/M/d"
        let orderDate = dateFormatter.string(from: currentDate)
        
        MenuController.shared.fetchOrder { (orderItem) in
            var orderNoPreFix = ""
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYYMMdd"
            let dateString = dateFormatter.string(from: date)
            //Ex:20201213  取得日期月日
//            let begin = dateString.index(dateString.startIndex, offsetBy: 4)
//            let end = dateString.index(dateString.endIndex, offsetBy: -1)
//            let monthDay = String(dateString[begin...end])
            
            if let orderItem = orderItem{
                let count = orderItem.count
                print("orderItem.count = \(orderItem.count)")
                if orderItem.count != 0 {
                    let arrayIndex = orderItem.count - 1
                    let orderNo1 = orderItem[arrayIndex].orderNo
                    let begin = orderNo1.index(orderNo1.startIndex, offsetBy: 0)
                    let end = orderNo1.index(orderNo1.startIndex, offsetBy: 7)
                    //取得orderNo前八位
                    orderNoPreFix = String(orderNo1[begin...end])
                    
                    print("dateString = \(dateString)")
                    print("orderNoPreFix = \(orderNoPreFix)")
                    //if 月日等於orderNo前八位
                    if dateString == orderNoPreFix{
                        var orderNoSuffix = ""
                        let arrayIndex = orderItem.count - 1
                        let orderNo = orderItem[arrayIndex].orderNo
                        print("orderItem[arrayIndex].orderNo = \(orderItem[arrayIndex].orderNo)")
                        let begin = orderNo.index(orderNo1.endIndex, offsetBy: -3)
                        let end = orderNo.index(orderNo1.endIndex, offsetBy: -1)
                        orderNoSuffix = String(orderNo1[begin...end])
                        
                        var nSerialNumber = 0
                        if let nOrderNoSuffix = Int(String(orderNoSuffix)){
                            nSerialNumber = nOrderNoSuffix + 1
                        }
                        var strSerialNumber = String(nSerialNumber)
                        switch strSerialNumber.count{
                        case 1:
                            strSerialNumber = "00" + strSerialNumber
                        case 2:
                            strSerialNumber = "0" + strSerialNumber
                        default:
                            break
                        }
                        self.orderNo = orderNoPreFix + strSerialNumber
                    
                    }else{
                        self.orderNo = dateString + "001"
                    }
                }else{
                    self.orderNo = dateString + "001"
                }
            }
            
            self.orderItem = [OrderItem(orderNo: self.orderNo,name: strName, drink: self.menu.name, sugar: self.sugar, ice: self.ice, price: String(self.menu.price), orderDate: orderDate)]
            
            MenuController.shared.submitOrder(orderItem: self.orderItem) { (result) in
                DispatchQueue.main.async {
                    if result == true {
                        let alertController = UIAlertController(title: "提示", message: "訂單送出成功", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "確定", style: .default) { (action) in
                             self.performSegue(withIdentifier: "toMenu", sender: nil)
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }else{
                        let alertController = UIAlertController(title: "提示", message: "訂單送出失敗", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "確定", style: .default) { (action) in
                            print("失敗")
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
    }
}
