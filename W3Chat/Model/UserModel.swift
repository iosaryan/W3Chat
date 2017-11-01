//
//  UserModel.swift
//  W3Chat
//
//  Created by ios2 on 10/10/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit


class UserModel: NSObject  {
    
   
    var username:    String = ""
    var userid:      String = ""
    var usermail:    String = ""
    var userphone:   String = ""
    var userimage:   String = ""
    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(_ dictionary: Dictionary<String, Any>) {
        self.init()
        
        username   = dictionary["user_name"] as! String
        userid     = dictionary["reg_id"] as! String
        usermail   = dictionary["email"] as!String
        userphone  = dictionary["contact_no"] as! String
         // userimage = dictionary["contact_no"] as! String
    }
    
    

    
//    // MARK: NSCoding
//    public convenience required init?(coder aDecoder: NSCoder) {
//
//        let username  = aDecoder.decodeObject(forKey: "username") as! String
//        let userid    = aDecoder.decodeObject(forKey: "userid") as! String
//        let usermail  = aDecoder.decodeObject(forKey: "usermail") as! String
//        let userimage = aDecoder.decodeObject(forKey: "userimage") as! String
//        let userphone = aDecoder.decodeObject(forKey: "userphone") as! String
//
//
//        self.init(username:username, userid:userid, usermail:usermail, userphone:userphone, userimage: userimage)
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(username, forKey: "username")
//        aCoder.encode(userid, forKey: "userid")
//        aCoder.encode(usermail, forKey: "usermail")
//        aCoder.encode(userimage, forKey: "userimage")
//        aCoder.encode(userphone, forKey: "userphone")
//    }
}
    
    



