//
//  InboxchatController.swift
//  W3Chat
//
//  Created by ios2 on 10/6/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//var InboxModel = [InboxModel]()
var chatArray = [] as Array
var ParamsDict = [String: Any]()

var refreshControl: UIRefreshControl!

let BOTTOM_HEIGHT     =  50 as CGFloat
let BOTTOM_MAX_HEIGHT =  120 as CGFloat


class InboxchatController: UIViewController , UITableViewDelegate ,UITableViewDataSource , UITextViewDelegate {
    @IBOutlet weak var InboxTable: UITableView!
    @IBOutlet weak var TextViewMsg: UITextView!
    
    @IBOutlet var constraint_bottomview: NSLayoutConstraint!
    
    @IBOutlet var BottomView_constrains: NSLayoutConstraint!
    
    var r_userid    = String()
    var r_username  = String()
    var r_userimage = String()
    
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.title = r_username
        
        InboxTable.register(UINib(nibName: "InboxCell", bundle: nil), forCellReuseIdentifier: "InboxCell")
        InboxTable.delegate = self
        InboxTable.dataSource = self
        InboxTable.separatorColor = UIColor.clear
        InboxTable.separatorStyle = .none
        InboxTable.reloadData()
        
        self.hideKeyboard()
        
        TextViewMsg.delegate = self
        self.TextViewMsg.layer.cornerRadius = 10.0
        self.TextViewMsg.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        //self.scheduledTimerWithTimeInterval()
        //self.receiveMsg()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        InboxTable.addSubview(refreshControl)
       
        
      
     
        
    }
    func refresh(sender:AnyObject) {
      print("press to refresh message")
      self.GetAllChatfromServer()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.GetAllChatfromServer()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell") as! InboxCell
        
        let InboxModel = chatArray [indexPath.item] as! [InboxModel]
        
        
        cell.lblMsg.text? = InboxModel[0].message
        cell.lblTime.text? = InboxModel[0].msg_time
       
        
        if InboxModel[0].IsMyMessage {
            cell.RightuserImage.isHidden = false
            cell.rightarrow.isHidden = false
            cell.lefttarrow.isHidden = true
            cell.LeftuserImage.isHidden = true
            
        }else{
            cell.LeftuserImage.isHidden = false
            cell.lefttarrow.isHidden = false
            cell.rightarrow.isHidden = true
            cell.RightuserImage.isHidden = true
        }
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You tapped cell number \(indexPath.row).")
        
    }
    
    
    
    
    
    
    @IBAction func SendMassageBtn(_ sender: Any) {
        
        let trimmedString = TextViewMsg.text.trimmingCharacters(in: .whitespaces)
        
        if trimmedString.count>0 {
            self.sendMessage(message: trimmedString)
        }
        TextViewMsg.text = ""
        BottomView_constrains.constant = 50
    }
    
    
    
    func sendMessage(message:String)  {
       print("SendMsg--->>",message)
        
        
        let someDate = Date()
        let timestamp = someDate.timeIntervalSince1970
        
        
        let r_id = "%@".format(parameters: String(r_userid) )
        let s_id = Helper.Instance.getUserDefalultValueFor(key: KEYS.UserId)
      
        
        ParamsDict =  ["s_id": s_id,
                       "r_id": r_id,
                       "time": String(timestamp),
                       "message":message,
                       "name": r_username,
                       "image": ""
                      ]
        
        //"2017-10-06 11:10 AM"
        addChatObjectToChatArray(dict: ParamsDict )
        self.sendMSgApiMethod(Param:ParamsDict.prettyPrintJSON() as! Dictionary<String, String> )
    }
    
    func sendMSgApiMethod(Param:Dictionary <String, String>){
        /***SHOW HUD***/
        DispatchQueue.main.async {
            showHUD(to_view: self.view)
        }
        
        Alamofire.request(Api.sendMsgapi, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            print(resData.result.value!)
            
            DispatchQueue.main.async {
                /***HIDE HUD***/
                hideHUD(for_view: self.view)
                
                let jsonObject = JSON(data:resData.data as Any as! Data)
                if jsonObject != JSON.null
                {
                    let status = jsonObject["status"].stringValue
                    let MSG    = jsonObject["Msg"].stringValue
                    
                    if status == "1" {}else {
                        self.alert(message: MSG)
                    }
                }else{
                    self.alert(message: Message.ServerError)
                }
            }
        }
    }
    
    
    
    
/******************************************************************/
/**************** RECEIVE MESSAGE CALLING WITH TIMER **************/
/**************** RECEIVE MESSAGE CALLING WITH TIMER  *************/
/******************************************************************/
   
    func receiveMsg()  {
        
        let r_id = "%@".format(parameters: String(r_userid) )
        let s_id = Helper.Instance.getUserDefalultValueFor(key: KEYS.UserId)
        
        let someDate = Date()
        let timestamp = someDate.timeIntervalSince1970
        
        let ParamsDict =  ["s_id": r_id,
                           "r_id": s_id,
                           "time": String(timestamp)
        ]
        
        self.recvMsgApi(Param:ParamsDict.prettyPrintJSON() as! Dictionary<String, String> )
    }
    
    
    func recvMsgApi(Param:Dictionary <String, String>){
        /***SHOW HUD***/
        DispatchQueue.main.async {
            showHUD(to_view: self.view)
        }
        
        Alamofire.request(Api.recvMsgapi, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            print(resData.result.value!)
            
            DispatchQueue.main.async {
                /***HIDE HUD***/
                hideHUD(for_view: self.view)
                
                let jsonObject = JSON(data:resData.data as Any as! Data)
                if jsonObject != JSON.null
                {
                    let status = jsonObject["status"].stringValue
                    let MSG    = jsonObject["Msg"].stringValue
                    
                    if status == "1" {
                        
                        var CommanDict = [String:Any]()
                        
                        for (key, value) in jsonObject["Data"].dictionaryValue {
                            CommanDict.updateValue(value.stringValue, forKey: key)
                        }
                        
                        print("RecvMSg--->>",CommanDict)
                        
                    }else {
                        self.alert(message: MSG)
                        
                    }
                }else{
                    self.alert(message: Message.ServerError)
                }
            }
        }
    }
  
/******************************************************************/
/****************** GET ALL CHAT FROM SERVER **********************/
/****************** GET ALL CHAT FROM SERVER **********************/
/******************************************************************/
    
    func GetAllChatfromServer() {
        let r_id = "%@".format(parameters: String(r_userid) )
        let s_id = Helper.Instance.getUserDefalultValueFor(key: KEYS.UserId)
        chatArray = [] as Array
        let  ParamsDict =  ["s_id": r_id,
                            "r_id": s_id,
                            "limit":""
        ]
        
        self.AllConversion_FromServer( Param:ParamsDict.prettyPrintJSON() as! Dictionary<String, String> )
    }
    
    
    func AllConversion_FromServer(Param:Dictionary <String, String>){
        
        /***SHOW HUD***/
        DispatchQueue.main.async {
            showHUD(to_view: self.view)
        }
        
        Alamofire.request(Api.ChatfromServer, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            print(resData.result.value!)
            
            DispatchQueue.main.async {
                /***HIDE HUD***/
                hideHUD(for_view: self.view)
                refreshControl.endRefreshing()
                
                let jsonObject = JSON(data:resData.data as Any as! Data)
                if jsonObject != JSON.null
                {
                    let status = jsonObject["status"].stringValue
                    let MSG    = jsonObject["Msg"].stringValue
                    
                    
                    if status == "1" {
                        
                        for item in jsonObject["Data"].arrayValue{
                            
                            
                            let s_id    = (item["s_id"].stringValue)
                            let id      = (item["id"].stringValue)
                            let time    = (item["time"].stringValue)
                            let r_id    = (item["r_id"].stringValue)
                            let message = (item["message"].stringValue)
                            let name    = (item["name"].stringValue)
                            
                            
                            let model = [InboxModel.init(msg_time:time , message: message, senderid: r_id, senderimage: "", msg_id: id,name: name, receiverid: s_id  , IsMyMessage: false  )]
                            
                            chatArray.append(model as Any)
                            //01133540313 tilwalsherver ji
                        }
                        var _: Timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(InboxchatController.scrollToBottomAnimated), userInfo: nil, repeats: false)
                        self.InboxTable.reloadData()
                        
                    }else {
                        self.alert(message: MSG)
                        
                    }
                }else{
                    self.alert(message: Message.ServerError)
                }
            }
        }
    }
    



    
    
/******************************************************************/
/************ to add object into Model and Array ****************/
    
    func addChatObjectToChatArray(dict:[String:Any])  {
        
        
    
        let S_id  =     (dict["s_id"] as! String)
        let name  =     (dict["name"] as! String)
        let msg   =     (dict["message"] as! String)
        let R_id  =     (dict["r_id"] as! String)
        let time  =     (dict["time"] as! String)
      //let image =     (dict["image"] as! String)
        
        let model = [InboxModel.init(msg_time:time , message: msg, senderid: S_id, senderimage: "", msg_id: "msg_id",name: name, receiverid: R_id  , IsMyMessage: false  )]
        
        chatArray.append(model as Any)
        
        var _: Timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(InboxchatController.scrollToBottomAnimated), userInfo: nil, repeats: false)
        InboxTable.reloadData()
        
    }
    
    
    
    
    
    
    
    @objc func keyboardWillAppear(notification: NSNotification){
        let info =  notification.userInfo
        let keyboardFrame: CGRect = (info![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let KeyBoardHeight = keyboardFrame.size.height as CGFloat
        self.view.layoutIfNeeded()
        
        constraint_bottomview.constant = KeyBoardHeight
        
        let duration:TimeInterval = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: {self.view.layoutIfNeeded()},
                       completion: nil)
        
        var _: Timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(InboxchatController.scrollToBottomAnimated), userInfo: nil, repeats: false)
        
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        
        
        self.constraint_bottomview.constant =  0.0
        let duration:TimeInterval = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
        
        var _: Timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(InboxchatController.scrollToBottomAnimated), userInfo: nil, repeats: false)
        
    }
    
    
    
    @objc func scrollToBottomAnimated() {
        
        let count =   InboxTable .numberOfRows(inSection: 0) as NSInteger
        
        if count > 0 {
            let oldLastCellIndexPath = NSIndexPath(row: count-1, section: 0)
            self.InboxTable.scrollToRow(at: oldLastCellIndexPath as IndexPath, at: .bottom, animated: true)
        }
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        let sizeThatFitsTextView = textView.sizeThatFits(CGSize(width: TextViewMsg.frame.size.width, height: CGFloat(MAXFLOAT)))
        let heightOfText = sizeThatFitsTextView as CGSize
        
        
        if(ceil(heightOfText.height)  > 40 && ceil(heightOfText.height) < BOTTOM_MAX_HEIGHT){
            
            self.view.layoutIfNeeded()
            BottomView_constrains.constant = BOTTOM_HEIGHT + heightOfText.height-20
            
            UIView.animate(withDuration: 0.10,
                           delay: TimeInterval(0),
                           options: UIViewAnimationOptions(rawValue: 0),
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
            
            TextViewMsg.isScrollEnabled = true
        }
        
        if (ceil(heightOfText.height) <= 120) {
            BottomView_constrains.constant = BottomView_constrains.constant
        }
        
        if (ceil(heightOfText.height) <= 40) {
            BottomView_constrains.constant = BOTTOM_HEIGHT
            TextViewMsg.isScrollEnabled = true
        }
        
        self.view.layoutIfNeeded()
    }
    
    
   
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
