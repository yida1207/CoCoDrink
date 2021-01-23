//
//  OrderDetailTableViewController.swift
//  CoCoDrink
//
//  Created by Yida on 2020/12/5.
//  Copyright © 2020 Yida. All rights reserved.
//

import UIKit

class OrderDetailTableViewController: UITableViewController {
        
    var orderItem = [OrderItem]()
    @IBOutlet weak var cupsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var topView: UIView!
        
    override func viewDidAppear(_ animated: Bool) {
        MenuController.shared.fetchOrder { (orderItem) in
            if let orderItem = orderItem, orderItem.count != 0{
                self.updateUI(with: orderItem)
            }else{
                DispatchQueue.main.async {
                    self.cupsLabel.text = "總計 0杯 "
                    self.totalPriceLabel.text = "總金額：$0"
                    let alertController = UIAlertController(title: "提示", message: "沒有訂單資料", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.borderWidth = 5
        topView.layer.borderColor = UIColor.blue.cgColor
                
        //navigationBar 圖片
        var image = UIImage()
        image = UIImage.init(named: "Logo")!
        image = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: UIImage.ResizingMode.stretch)
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        //navigationBar 圖片
        
        //tabBar 背景圖
        tabBarController?.tabBar.backgroundImage = UIImage(named: "tabBarBg")
        //tabBar 背景圖

        //tableView 背景圖
        let bgImage = UIImage(named: "background")
        tableView.backgroundView = UIImageView(image: bgImage)
        //tableView 背景圖
        
        MenuController.shared.fetchOrder { (orderItem) in
            if let orderItem = orderItem, orderItem.count != 0{
                self.updateUI(with: orderItem)
            }else{                
                DispatchQueue.main.async {
                    self.cupsLabel.text = "總計 0杯 "
                    self.totalPriceLabel.text = "總金額：$0"
                    let alertController = UIAlertController(title: "提示", message: "沒有訂單資料", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func updateUI(with orderItem:[OrderItem]){
        DispatchQueue.main.async {
            var totalPrice = 0
            self.orderItem = orderItem
            self.cupsLabel.text = "總計 " + String(orderItem.count) + "杯 "
            for item in orderItem {
                totalPrice = totalPrice + Int(item.price)!
            }
            self.totalPriceLabel.text = "總金額：$\(String(totalPrice))"
            self.tableView.reloadData()
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderDetailTableViewCell.self)", for: indexPath) as! OrderDetailTableViewCell

        // Configure the cell...
        cell.orderNoLabel.text = "訂單編號：\(orderItem[indexPath.row].orderNo)"
        cell.nameLabel.text = orderItem[indexPath.row].name
        cell.drinkLabel.text = orderItem[indexPath.row].drink
        cell.sugarLabel.text = orderItem[indexPath.row].sugar
        cell.iceLabel.text = orderItem[indexPath.row].ice
        cell.priceLabel.text = "$" + orderItem[indexPath.row].price
        cell.orderDateLabel.text = orderItem[indexPath.row].orderDate
        cell.orderImageView.image = nil
        
        DispatchQueue.main.async {
            cell.orderImageView.image = UIImage(named: self.orderItem[indexPath.row].drink)
        }
        return cell
    }
    
    //左滑顯示
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { (action, view, completionHandler) in
            
            let alertController = UIAlertController(title: "提示", message: "是否刪除", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "是", style: .default) { (action) in
                
                MenuController.shared.deleteOrder(orderItem: self.orderItem[indexPath.row]) { (isDelete) in
                    if isDelete == true{
                        self.orderItem.remove(at: indexPath.row)
                        
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "提示", message: "刪除成功", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (action) in
                                self.updateUI(with: self.orderItem)
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }else{
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "提示", message: "刪除失敗", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (action) in  }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        return
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        let modifyAction = UIContextualAction(style: .normal, title: "修改") { (action, view, completionHandler) in
            MenuController.segueId = "toOrderDetail"
            self.performSegue(withIdentifier: "toModifyOrder", sender: indexPath)
            completionHandler(true)                        
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, modifyAction])
    }
    
    @IBAction func unwindToOrderDetail(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? ModifyOrderViewController{
            let returnOrderNo = sourceViewController.returnOrderItem[0].orderNo
            for i in 0...orderItem.count-1{
                if orderItem[i].orderNo == returnOrderNo{
                    orderItem[i] = sourceViewController.returnOrderItem[0]
                }
            }
            self.updateUI(with: orderItem)
        }
    }
    var prepareOrderItem:OrderItem!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath,
            let controller = segue.destination as? ModifyOrderViewController{
            controller.orderItem = orderItem[indexPath.row]
            prepareOrderItem = orderItem[indexPath.row]
        }
    }
}
