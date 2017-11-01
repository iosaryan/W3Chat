//
//  Functions.swift
//  W3Chat
//
//  Created by ios2 on 10/16/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import Foundation

import CoreData
import Alamofire
import MBProgressHUD
import SwiftyJSON








/******************************************************************/
/*******************   GLOBAL FUNCTION  ***************************/
/*******************   GLOBAL FUNCTION  ***************************/
/*******************   GLOBAL FUNCTION  ***************************/
/******************************************************************/

class Helper{

    
   
    
    private static let _instance = Helper();
    private init() {}
    
    
    static var Instance: Helper {
        return _instance;
    }
    
     var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
func UIColorFromRGB(rgb: Int, alpha: Float) -> UIColor {
    let red = CGFloat(Float(((rgb>>16) & 0xFF)) / 255.0)
    let green = CGFloat(Float(((rgb>>8) & 0xFF)) / 255.0)
    let blue = CGFloat(Float(((rgb>>0) & 0xFF)) / 255.0)
    let alpha = CGFloat(alpha)
    
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}



 func isValidEmail(email: String?) -> Bool {
    guard let email = email else { return false }
    guard !email.isEmpty else { return false }
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

    
    
    
//MARK: UserDefauls

func setUserDefaultWith(key:String,value:String) -> Void {
    
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
    
} // USE :>> ---- setUserDefaultWith(key: "", value: profileData.value(forKey: "avatar_url") as! String)

    func getUserDefalultValueFor(key:String) -> Any {
        
        return UserDefaults.standard.value(forKey: key)
    }

   
/************************** END HELPER CLASS ****************************/
}



/******************************************************************/
/**********************  MBPROGRESS HUD  **************************/
/**********************  MBPROGRESS HUD  **************************/
/******************************************************************/

func showHUD(to_view: UIView) {
    let hud = MBProgressHUD.showAdded(to: to_view, animated: true)
    // hud.label.text = "Loading..."
    hud.contentColor = AppColor
}

func hideHUD(for_view: UIView) {
    MBProgressHUD.hide(for: for_view, animated: true)
}
