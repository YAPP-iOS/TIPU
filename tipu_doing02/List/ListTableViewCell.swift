//
//  ListTableViewCell.swift
//  tipu_doing02
//
//  Created by JunHee on 01/04/2018.
//  Copyright © 2018 JunHee. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var ticketImage: UIImageView!
    @IBOutlet var deadlineText: UILabel!
    @IBOutlet var bar: UIView!
    @IBOutlet var rightarrow: UIImageView!
    @IBOutlet var ticketBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
