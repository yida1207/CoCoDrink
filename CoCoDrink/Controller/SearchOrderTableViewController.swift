//
//  SearchOrderTableViewController.swift
//  CoCoDrink
//
//  Created by Yida on 2021/1/2.
//  Copyright © 2021 Yida. All rights reserved.
//

import UIKit

class SearchOrderTableViewController: UITableViewController, UISearchResultsUpdating {
        
    var orderItem = [OrderItem]()
    var searchOrder = [OrderItem]()
    var searchController:UISearchController!
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        searchOrder = orderItem.filter({ (orderItem) -> Bool in
            return orderItem.name.contains(searchString)
        })
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MenuController.shared.fetchOrder { (orderItem) in
            if let orderItem = orderItem, orderItem.count != 0{
                self.updateUI(with: orderItem)
            }else{
                DispatchQueue.main.async {                    
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
                    let alertController = UIAlertController(title: "提示", message: "沒有訂單資料", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
                
        //searchBar
        //參數傳入nil代表搜尋結果會顯示於正在搜尋的視圖中
        searchController = UISearchController(searchResultsController: nil)
        // 將更新搜尋結果的對象設為 self
        searchController.searchResultsUpdater = self
        // 搜尋時是否使用燈箱效果 (會將畫面變暗以集中搜尋焦點)
        searchController.dimsBackgroundDuringPresentation = false
        //搜尋時是否隱藏NavigationBar
        searchController.hidesNavigationBarDuringPresentation = false
//        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "請輸入訂購人姓名"        
        // 將搜尋框擺在 tableView 的 header
        tableView.tableHeaderView = searchController.searchBar
        //頁面向左滑動 searchBar跟著滑動
        definesPresentationContext = true
        // 搜尋時是否隱藏 NavigationBar
        navigationItem.hidesSearchBarWhenScrolling = false
        //searchBar
    }
    
    func updateUI(with orderItem:[OrderItem]){
        DispatchQueue.main.async {
            var totalPrice = 0
            self.orderItem = orderItem
            for item in orderItem {
                totalPrice = totalPrice + Int(item.price)!
            }
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
        if searchController?.isActive == true{
            return searchOrder.count
        }else{
            return orderItem.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderDetailTableViewCell.self)", for: indexPath) as! OrderDetailTableViewCell

        // Configure the cell...
        if searchController?.isActive == true{
            cell.orderNoLabel.text = "訂單編號：\(searchOrder[indexPath.row].orderNo)"
            cell.nameLabel.text = searchOrder[indexPath.row].name
            cell.drinkLabel.text = searchOrder[indexPath.row].drink
            cell.sugarLabel.text = searchOrder[indexPath.row].sugar
            cell.iceLabel.text = searchOrder[indexPath.row].ice
            cell.priceLabel.text = "$" + searchOrder[indexPath.row].price
            cell.orderDateLabel.text = searchOrder[indexPath.row].orderDate
            cell.orderImageView.image = nil
            DispatchQueue.main.async {
                cell.orderImageView.image = UIImage(named: self.searchOrder[indexPath.row].drink)
            }
        }else{
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
                        self.updateUI(with: self.orderItem)
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "提示", message: "刪除成功", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (action) in  }
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
            MenuController.segueId = "toSearchOrder"
            self.performSegue(withIdentifier: "toModifyOrder", sender: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, modifyAction])
    }
    
    @IBAction func unwindToSearchOrder(_ unwindSegue: UIStoryboardSegue) {
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
            if searchController?.isActive == true{
                controller.orderItem = searchOrder[indexPath.row]
                prepareOrderItem = searchOrder[indexPath.row]
            }else{
                controller.orderItem = orderItem[indexPath.row]
                prepareOrderItem = orderItem[indexPath.row]
            }
        }
    }
}
