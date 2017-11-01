//
//  InboxCell.swift
//  W3Chat
//
//  Created by ios2 on 10/6/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit

class InboxCell: UITableViewCell {

    
    @IBOutlet weak var RightuserImage: UIImageView!
    @IBOutlet weak var LeftuserImage: UIImageView!
    
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var lblMsg: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var rightarrow: UIImageView!
    @IBOutlet weak var lefttarrow: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.BGView.layer.cornerRadius = 10.0
        self.BGView.clipsToBounds = true
        
        self.RightuserImage.layer.cornerRadius = RightuserImage.frame.height / 2.0
        self.RightuserImage.clipsToBounds = true
        self.LeftuserImage.layer.cornerRadius = LeftuserImage.frame.height / 2.0
        self.LeftuserImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
