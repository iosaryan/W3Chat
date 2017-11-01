//
//  Extensions.swift
//  W3Chat
//
//  Created by ios2 on 10/16/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import MBProgressHUD
import SwiftyJSON






/*******************************************************************/
/*******************   CLASS CONSTANT  ***************************/
/*******************   CLASS CONSTANT  ***************************/
/*******************   CLASS CONSTANT  ***************************/
/*******************   CLASS CONSTANT  ***************************/
/*******************************************************************/
class Extensions: NSObject {
    
    static let SCREEN_SIZE = UIScreen.main.fixedCoordinateSpace.bounds
    static let SCREEN_WIDTH = SCREEN_SIZE.width
    static let SCREEN_HEIGHT = SCREEN_SIZE.height
   
    /*
     struct ScreenSize
     {
     static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
     static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
     static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
     static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
     }
     */
    
    
    
}




/******************************************************************/
/**************** EXTENSION UIViewController **********************/
/**************** EXTENSION UIViewController **********************/
/******************************************************************/
extension UIViewController {
    
   
    
    func alert(message: String, title: String = "") {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        alertController.view.tintColor = AppColor
        
        self.present(alertController, animated: true, completion: nil)
    }
}



extension UserDefaults { //**is logged in or not
    enum UserDefaultsKeys: String{
        case isLoggedIn
    }
    
    func setIsLoggedIn(value:Bool){
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool{
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        
    }
    /* USE------->>>>>>.
     UserDefaults.standard.setIsLoggedIn(value: true)
     or
     UserDefaults.standard.setIsLoggedIn(value: false)
     */
}





extension Notification.Name {
    //static let userlogout = Notification.Name(Userlogout)
    //static let Signup     = Notification.Name(userSignup)
    
    /* USE----->>>>>
     DispatchQueue.main.async {
     NotificationCenter.default.post(name: .userlogout, object: nil)}
     */
}


extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}






extension String {
    func format(parameters: CVarArg...) -> String {
        return String(format: self, arguments: parameters)
    }
} //USE---->>> let Time = "%@%@".format(parameters: timestamp)


extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }// USE----->>> ("1481721300" as! Double).getDateStringFromUTC() // "Dec 14, 2016"
}

extension Double {
    func convertTimeStamp(timeStamp:Double) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy hh:mm a"
        dateFormatter.locale =  Locale.current
        let date = NSDate(timeIntervalSince1970: timeStamp/1000 )
        let s = dateFormatter.string(from: date as Date)
        
        print (s)
        return s
    }
}


extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.height
    }
}








//*** Extension for JSONObject -> typealias JSONObject = [String:Any]
protocol CustomStringProtocol {}
extension String: CustomStringProtocol {}
extension Dictionary where Key:CustomStringProtocol {
    
    func prettyPrintJSON() -> Dictionary{
        
         let jsonData = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
  
          let decoded = try! JSONSerialization.jsonObject(with: jsonData, options: [])
        
          let dictFromJSON = decoded as? [String:String]
     
         return dictFromJSON as! Dictionary
}
}


