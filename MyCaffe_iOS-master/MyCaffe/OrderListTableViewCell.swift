//
//  OrderListTableViewCell.swift
//  MyCaffe
//
//  Created by YoungKwangLee on 2016. 9. 2..
//  Copyright © 2016년 YoungKwangLee. All rights reserved.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var cafeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
