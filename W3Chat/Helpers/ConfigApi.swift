//
//  ConfigApi.swift
//  W3Chat
//
//  Created by ios2 on 10/9/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import Foundation




/****************************************************************/
/************************* STAGING URL KEY **************************/
let SignUp            = "https://projects.w3care.net/w3api/api.php?method=sign_up"
let Login             = "https://projects.w3care.net/w3api/api.php?method=user_login"
let GetallActiveUser  = "https://projects.w3care.net/w3api/api.php?method=GetallActiveUser"


/****************************************************************/
/************************* API METHOD KEY ***************************/
struct API {
    static let SignUp           = "sign_up"
    static let Login            = "user_login"
    static let GetallActiveUser = "GetallActiveUser"
}


/********************************************************************/
/************************* NSUSER-DEFAULTS-KEY ***************************/
let UserLoginkey = "UserLoginkey"
let UserId       = "UserIdkey"


/********************************************************************/
/************************* NSNOTIFICATION-KEY ***************************/
extension Notification.Name {
    static let Userlogout = Notification.Name("Userlogout")
    
    /* USE----->>>>>
     DispatchQueue.main.async {
     NotificationCenter.default.post(name: .Userlogout, object: nil)}
     */
    
    
}
/*********************************************************************/
/************************* USER ALERT MESSAGE KEY ************************/
let msg_ServerError               = "Server Error"
let msg_Fill_username             = "Please Enter Your Name"
let msg_ValidationEmail           = "Please check your Email Address"
let msg_Validation_MobileNo       =  "Please Enter Mobile No."
let msg_Validation_Email_Password = "Your Email ID or password was entered incorrectly"

