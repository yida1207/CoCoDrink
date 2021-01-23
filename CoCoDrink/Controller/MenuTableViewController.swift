//
//  MenuTableViewController.swift
//  CoCoDrink
//
//  Created by Yida on 2020/11/30.
//  Copyright © 2020 Yida. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menu = [Menu]()

    @IBOutlet weak var randomButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        randomButton.layer.cornerRadius = 5.0
        
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
                
        MenuController.shared.fetchMenu { (menu) in
            if let menu = menu{
                self.updateUI(with: menu)
            }
        }
        
    }
    
    func updateUI(with menu:[Menu]){
        DispatchQueue.main.async {
            self.menu = menu
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
        return menu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MenuTableViewCell.self)", for: indexPath) as! MenuTableViewCell

        // Configure the cell...
        cell.nameLabel.text = menu[indexPath.row].name
        cell.priceLabel.text = "$" + String(menu[indexPath.row].price)
        cell.menuImageView.image = nil
        
        DispatchQueue.main.async {
            cell.menuImageView.image = UIImage(named: self.menu[indexPath.row].name)
        }

        return cell
    }
    
    @IBSegueAction func showOrderPage(_ coder: NSCoder) -> OrderPageViewController? {
        let controller = OrderPageViewController(coder: coder)
        if let row = tableView.indexPathForSelectedRow?.row{
            controller?.menu = menu[row]
        }        
        return controller
    }
    
    @IBAction func unwindToMenu(_ unwindSegue: UIStoryboardSegue) {
    }
}
