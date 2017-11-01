//
//  SignUpVC.swift
//  W3Chat
//
//  Created by ios2 on 10/5/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class SignUpVC: UIViewController  {
    
  
    
    
    

    var window: UIWindow?
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var BCView: UIView!
    
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var facebookBtn: UIButton!
    
    var DataDict = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Sign Up"
        
        
        self.ScrollView.contentSize = CGSize(width: BCView.frame.size.width , height: BCView.frame.height)
        ScrollView.addSubview(BCView)
        
        self.EmailText.layer.borderWidth = 1
        self.EmailText.layer.borderColor = ThirdAppColor.cgColor
        
        self.PasswordText.layer.borderWidth = 1
        self.PasswordText.layer.borderColor = ThirdAppColor.cgColor
        
        self.EmailText.attributedPlaceholder = NSAttributedString(string: " Email Address*", attributes: [ NSForegroundColorAttributeName : ThirdAppColor])
        
        self.PasswordText.attributedPlaceholder = NSAttributedString(string: " Enter Password*", attributes: [ NSForegroundColorAttributeName : ThirdAppColor])
        
        
        self.hideKeyboard()
        
        if (FBSDKAccessToken.current() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
//            let loginView : FBSDKLoginButton = FBSDKLoginButton()
//            self.view.addSubview(loginView)
//            loginView.center = self.view.center
//            loginView.readPermissions = ["public_profile", "email", "user_friends"]
//            loginView.delegate = self
        }
        
        
    }

    @IBAction func CancelBtn(_ sender: Any) {
        
         dismiss(animated:true, completion: nil)
        
    }
    
    
    @IBAction func getStarted(_ sender: Any) {
        
         let Validation =   Helper.Instance.isValidEmail(email:self.EmailText.text!)
        
        if Validation == false {
            self.alert(message: Message.Validation_Email_Password)
        }
        else if(PasswordText.text?.characters.count)!<6 {
                self.alert(message: Message.Validation_Email_Password)
        }else{
            DataDict =    ["email":self.EmailText.text as AnyObject,
                           "password":PasswordText.text as AnyObject,
                           ]
          
           
            self.RestAPiMethod(Param:DataDict.prettyPrintJSON() as! Dictionary<String, String> )
        }
  
    }

    
    func RestAPiMethod(Param:Dictionary <String, String> ) {
        
        /***SHOW HUD***/
        DispatchQueue.main.async {
            showHUD(to_view: self.view)
        }
        
        if RestApi.Instance.isReachable(){
            
            RestApi.Instance.postService(content_type: REQUEST_HEADER.json, WebAPI: Api.Login, parameters: Param , helperCompletionHandler: { (response) in
                
                /***HIDE HUD***/
                DispatchQueue.main.async {
                    hideHUD(for_view: self.view)
                }
                
                let dict = response as! NSDictionary
                
                let status = dict.object(forKey: "status") as! Bool
                let MSG    = dict.object(forKey: "Msg") as! String
                
                if status as Bool == true {
                    
                    let model  = [UserModel.init(dict.object(forKey: "Data") as! Dictionary<String, Any>)]
                    let reg_id  = model[0].userid
                    
                    Helper.Instance.setUserDefaultWith(key: KEYS.UserId, value: reg_id)
                    UserDefaults.standard.setIsLoggedIn(value: true)
                    
                    let newViewController = ChatVC()
                    //*** adding a navigation controller when push from present
                    let navigationController = UINavigationController(rootViewController: newViewController)
                    self.present(navigationController, animated:true, completion:nil)
                    
                }else{
                    self.alert(message: MSG)
                }
                
            })
            
        }else{
            self.alert(message: Message.INTERNET_CONNECTIVITY)
        }
    }
    
    
  
   
    
    @IBAction func facebook_login(_ sender: Any) {
       
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
//********************* Facebook Delegate Methods
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result!)
                    self.alert(message: "Succssfully Login")
                }
            })
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
