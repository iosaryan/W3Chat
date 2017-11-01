//
//  ConfigApi.swift
//  W3Chat
//
//  Created by ios2 on 10/9/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import Foundation









/****************************************************************/
/************************ APP COLORS ****************************/
/****************************************************************/
var AppColor       = UIColor(red: 30/255, green: 165/255, blue: 117/255, alpha: 1.0)
var SecondAppColor = UIColor(red: 52/255, green: 63/255, blue: 71/255, alpha: 1.0)
var ThirdAppColor  = UIColor(red: 123/255, green: 130/255, blue: 135/255, alpha: 1.0)


struct KEYS {
/********************************************************************/
/************************* NSUSER-DEFAULTS-KEY ***************************/
/********************************************************************/
static let UserLoginkey = "UserLoginkey"
static let UserId       = "UserIdkey"


/********************************************************************/
/************************* NSNOTIFICATION-KEY ***************************/
/********************************************************************/
static let userSignup = "usersignup"
static let Userlogout = "Userlogout"
    
    
}

/*********************************************************************/
/************************* USER ALERT MESSAGE KEY ************************/
/********************************************************************/
struct Message {
static let ServerError               = "Server Error"
static let Fill_username             = "Please Enter Your Name"
static let Fill_password             = "Password should be 6 char or more!!"

static let ValidationEmail           = "Please check your Email Address"
static let Validation_MobileNo       = "Please Enter Mobile No."
static let Validation_Email_Password = "Your Email ID or password was entered incorrectly"
static let INTERNET_CONNECTIVITY     = "Please check your internet connection."
}
