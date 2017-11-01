//
//  ChatCell.swift
//  W3Chat
//
//  Created by ios2 on 10/5/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var IMG: UIImageView!
    @IBOutlet weak var NameText: UILabel!
    @IBOutlet weak var EmailText: UILabel!
    @IBOutlet weak var OnlineLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.IMG.layer.cornerRadius = IMG.frame.height / 2.0
        self.IMG.clipsToBounds = true
        //self.IMG.layer.borderWidth = 1
        //self.IMG.layer.borderColor = UIColor.white.cgColor
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
