//
//  OrderDetailTableViewCell.swift
//  CoCoDrink
//
//  Created by Yida on 2020/12/5.
//  Copyright © 2020 Yida. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
