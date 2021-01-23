//
//  RandomViewController.swift
//  CoCoDrink
//
//  Created by Yida on 2021/1/14.
//  Copyright © 2021 Yida. All rights reserved.
//

import UIKit

class RandomViewController: UIViewController {
    
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var drinkLabel: UILabel!
    var menu:[Menu]!
    var deliver:Menu!
    var menuList:[Int:Menu] = [:]
    var time = 36
    var myTimer:Timer!
    var drinkIndex:Int!
    var deliverMenu:Menu!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        MenuController.shared.fetchMenu { (menu) in
            if let menu = menu{
                self.menu = menu
            }
        }        
        
//        for (index, value) in menu.enumerated(){
//            menuList[index] = value
//        }
    }
    
    @IBAction func play(_ sender: Any) {
        playButton.isEnabled = false
        drinkIndex = Int.random(in: 0...42)
        myTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(RandomViewController.switchImage), userInfo: nil, repeats: true)
    }
    
    @objc func switchImage(){
        time -= 1
        
        if time == 0{
            myTimer?.invalidate()
            playButton.isEnabled = true
            menuImageView.image = UIImage(named: menu[drinkIndex].name)
            drinkLabel.text = menu[drinkIndex].name
            deliverMenu = menu[drinkIndex]
            time = 36
            
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
                self.performSegue(withIdentifier: "randomToOrderPage", sender: nil)
            }
        }else{
            let r = Int.random(in: 0...42)
            menuImageView.image = UIImage(named: menu[r].name)
            drinkLabel.text = menu[r].name
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? OrderPageViewController
        controller?.menu = menu[drinkIndex]        
    }
}
