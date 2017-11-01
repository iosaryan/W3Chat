//
//  ChatModel.swift
//  W3Chat
//
//  Created by ios2 on 10/6/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit


class ChatModel: NSObject {
    
    
    var user_id    : String = ""
    var user_name  : String = ""
    var password   : String = ""
    var contact_no : String = ""
    var email      : String = ""
    var image      : String = ""
    
   
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
   
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        user_id    = dictionary["user_id"] as! String
        user_name  = dictionary["user_name"] as! String
        password   = dictionary["password"] as!String
        contact_no = dictionary["contact_no"] as! String
        email      = dictionary["email"] as! String
        
    }
    
}


