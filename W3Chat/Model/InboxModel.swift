//
//  InboxModel.swift
//  W3Chat
//
//  Created by ios2 on 10/27/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit

class InboxModel: NSObject {

    
    var msg_time:    String = ""
    var message:     String = ""
    var senderid:    String = ""
    var senderimage: String = ""
    var msg_id:      String = ""
    var name:        String = ""
    var receiverid:  String = ""
    var IsMyMessage: Bool
    
    init(msg_time: String, message: String, senderid: String, senderimage: String, msg_id: String,name: String, receiverid:String , IsMyMessage: Bool  ) {
        
        self.msg_time = msg_time
        self.message = message
        self.senderid = senderid
        self.senderimage = senderimage
        self.name = name
        self.receiverid = receiverid
        self.msg_id = msg_id
        //self.IsMyMessage = IsMyMessage
        
        let user_id = String(describing: UserDefaults.standard.object(forKey: KEYS.UserId)!)
        if user_id == self.senderid {
            self.IsMyMessage = true
        }else{
            self.IsMyMessage = false
        }
        
        
    }
    
}
