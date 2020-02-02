//
//  DairyTableViewCell.swift
//  newDairy
//
//  Created by 邵贵林 on 2019/9/13.
//  Copyright © 2019年 邵贵林. All rights reserved.
//

import UIKit

class DairyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
