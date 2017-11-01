//
//  LoginVC.swift
//  W3Chat
//
//  Created by ios2 on 10/5/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

class LoginVC: UIViewController  , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate{
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet var BGView: UIView!
    
    @IBOutlet weak var SignUpBtn: UIButton!
    @IBOutlet weak var LoginBtn: UIButton!
  
    @IBOutlet weak var NameTxt: UITextField!
    @IBOutlet weak var MobileTxt: UITextField!
    
    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var Passwordtxt: UITextField!
    
    @IBOutlet weak var GetStatredBtn: UIButton!
    ////******** Assign Var *********////
    ////******** Assign Var *********////
    ////******** Assign Var *********////
    ////******** Assign Var *********////
    
    var DataDict = [String: Any]()
    
    
    
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.title = "Log In"
        
        
        self.BGView.frame = CGRect (x:0 , y:0 , width:Extensions.SCREEN_WIDTH , height:BGView.frame.height)
        self.ScrollView.contentSize = CGSize(width: BGView.frame.size.width , height: BGView.frame.height)
        ScrollView.addSubview(BGView)
        
        self.NameTxt.layer.borderWidth = 1
        self.NameTxt.layer.borderColor = ThirdAppColor.cgColor
        
        self.MobileTxt.layer.borderWidth = 1
        self.MobileTxt.layer.borderColor = ThirdAppColor.cgColor
        
        self.EmailTxt.layer.borderWidth = 1
        self.EmailTxt.layer.borderColor = ThirdAppColor.cgColor
        
        self.Passwordtxt.layer.borderWidth = 1
        self.Passwordtxt.layer.borderColor = ThirdAppColor.cgColor
        
        self.NameTxt.attributedPlaceholder = NSAttributedString(string: " User Name*", attributes: [ NSForegroundColorAttributeName : ThirdAppColor])

         self.MobileTxt.attributedPlaceholder = NSAttributedString(string: " Mobile No*", attributes: [ NSForegroundColorAttributeName : ThirdAppColor])
        
         self.EmailTxt.attributedPlaceholder = NSAttributedString(string: " Email Address*", attributes: [ NSForegroundColorAttributeName : ThirdAppColor])
        
         self.Passwordtxt.attributedPlaceholder = NSAttributedString(string: " Set a Password*", attributes: [ NSForegroundColorAttributeName : ThirdAppColor])
        
        SignUpBtn.isSelected = true
        MobileTxt.delegate = true as? UITextFieldDelegate
        
        self.hideKeyboard()
        
    }
    
    
    @IBAction func SignUP(_ sender: Any) {
        
        if SignUpBtn.isSelected {
            
            LoginBtn.backgroundColor = SecondAppColor
            SignUpBtn.backgroundColor = AppColor
            
            LoginBtn.setTitleColor(ThirdAppColor, for: .normal)
            SignUpBtn.titleLabel?.textColor = UIColor.white
            
        }
    }
    
    
    
    
    
    @IBAction func LoginPage(_ sender: Any) {
        
        if SignUpBtn.isSelected {
            LoginBtn.backgroundColor = AppColor
            SignUpBtn.backgroundColor = SecondAppColor
            
            LoginBtn.setTitleColor(.white, for: .normal)
            SignUpBtn.titleLabel?.textColor = ThirdAppColor
            
            let vc = SignUpVC()
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    
    
    
    
    
    
    @IBAction func GetStarted(_ sender: Any) {
        
        let Validation =  Helper.Instance.isValidEmail(email:self.EmailTxt.text!)
        
        if ((NameTxt.text?.characters.count)! < 1) {
            alert(message: Message.Fill_username)
        }else if ((MobileTxt.text?.characters.count)! < 10) {
            alert(message: Message.Validation_MobileNo)
        }else if Validation == false {
            alert(message: Message.ValidationEmail)
        }else if((Passwordtxt.text?.characters.count)! <= 5){
            alert(message: Message.Fill_password)
        }
            
        else {
            
            DataDict =    ["user_name": NameTxt.text!,
                           "password": Passwordtxt.text!,
                           "contact_no": MobileTxt.text!,
                           "email":EmailTxt.text!,
            ]
            
            self.RestAPiMethod(Param:DataDict.prettyPrintJSON() as! Dictionary<String, String>)
        }
    }
    
    func RestAPiMethod(Param:Dictionary <String, String> ) {
        
        /***SHOW HUD***/
        DispatchQueue.main.async {
            showHUD(to_view: self.view)
        }
        
        if RestApi.Instance.isReachable(){
            
            RestApi.Instance.postService(content_type: REQUEST_HEADER.json, WebAPI: Api.SignUp, parameters: Param , helperCompletionHandler: { (response) in
                
                /***HIDE HUD***/
                DispatchQueue.main.async {
                    hideHUD(for_view: self.view)
                }
                
                let dict = response as! NSDictionary
                
                let status = dict.object(forKey: "status") as! Bool
                let MSG    = dict.object(forKey: "Msg") as! String
                
                if status as Bool == true {
                    //*** Clear All Fields
                    self.NameTxt.text     = ""
                    self.Passwordtxt.text = ""
                    self.MobileTxt.text   = ""
                    self.EmailTxt.text    = ""
                    
                    // Create the alert controller
                    let alertController = UIAlertController(title:MSG, message: "please login", preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                        
                    }
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
                        UIAlertAction in
                        NSLog("ok Pressed")
                        let vc = SignUpVC()
                        self.present(vc, animated: true, completion: nil)
                    }
                    // Add the actions
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                }else{
                    self.alert(message: MSG)
                }
                
            })
            
        }else{
            self.alert(message: Message.INTERNET_CONNECTIVITY)
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
