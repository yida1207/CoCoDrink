//
//  ModifyOrderViewController.swift
//  CoCoDrink
//
//  Created by Yida on 2020/12/12.
//  Copyright © 2020 Yida. All rights reserved.
//

import UIKit

class ModifyOrderViewController: UIViewController ,UITextFieldDelegate {
    
    var orderItem:OrderItem?
    var returnOrderItem:[OrderItem]!
    
    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var modifyOrderButton: UIButton!
    @IBOutlet weak var sugarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    var sugar:String!
    var ice:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modifyOrderButton.layer.cornerRadius = 5.0
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        orderNoLabel.text = orderItem?.orderNo
        if let drink = orderItem?.drink{
            drinkImageView.image = UIImage(named: drink)
        }
        drinkLabel.text = orderItem?.drink
        priceLabel.text = "$" + (orderItem?.price)!
        nameTextField.text = orderItem?.name
        sugar = orderItem?.sugar
        switch sugar{
        case "正常糖":
            self.sugarSegmentedControl.selectedSegmentIndex = 0
        case "七分":
            self.sugarSegmentedControl.selectedSegmentIndex = 1
        case "半糖":
            self.sugarSegmentedControl.selectedSegmentIndex = 2
        case "微糖":
            self.sugarSegmentedControl.selectedSegmentIndex = 3
        case "無糖":
            self.sugarSegmentedControl.selectedSegmentIndex = 4
        default:
            break
        }
        
        ice = orderItem?.ice
        switch ice{
        case "正常冰":
            self.iceSegmentedControl.selectedSegmentIndex = 0
        case "少冰":
            self.iceSegmentedControl.selectedSegmentIndex = 1
        case "去冰":
            self.iceSegmentedControl.selectedSegmentIndex = 2
        case "溫":
            self.iceSegmentedControl.selectedSegmentIndex = 3
        case "熱":
            self.iceSegmentedControl.selectedSegmentIndex = 4
        default:
            break
        }
        
        nameTextField.delegate = self
        //尚未輸入時的預設顯示提示文字
        nameTextField.placeholder = "請輸入名字"
        //輸入框右邊顯示清除按鈕時機
        nameTextField.clearButtonMode = .whileEditing
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
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func modifyOrder(_ sender: Any) {
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
        
        returnOrderItem = [OrderItem(orderNo: orderNoLabel.text!, name: (orderItem?.name)!, drink: drinkLabel.text!, sugar: sugar, ice: ice, price: (orderItem?.price)!, orderDate: orderDate)]
        
        MenuController.shared.modifyOrder(orderItem: returnOrderItem) { (isSuccess) in
            DispatchQueue.main.async{
                if isSuccess == true{
                    let alertController = UIAlertController(title: "提示", message: "訂單修改成功", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default) {
                        (action) in
                        if MenuController.segueId == "toOrderDetail"{
                            self.performSegue(withIdentifier: "toOrderDetail", sender: nil)
                        }else{
                            self.performSegue(withIdentifier: "toSearchOrder", sender: nil)
                        }
                    }                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    let alertController = UIAlertController(title: "提示", message: "訂單修改失敗", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default) { (action) in }                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
        }
    }
}
