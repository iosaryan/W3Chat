//
//  ChatVC.swift
//  W3Chat
//
//  Created by ios2 on 10/5/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import UserNotifications
import UserNotificationsUI


//var refreshControl: UIRefreshControl!


var chatArr : [Any] = []

 let requestIdentifier = "localNotification" //identifier is to cancel the notification request

class ChatVC: UIViewController , UITableViewDelegate ,UITableViewDataSource  {
    
    @IBOutlet weak var ChatTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        
        
        self.title = "Home"
       
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "sidemenu"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 10  , height: 10)
        btn1.addTarget(self, action: #selector((SSASideMenu.presentLeftMenuViewController)), for: .touchUpInside)
        
        let item1 = UIBarButtonItem(customView: btn1 )
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)
        
        ChatTable.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "Cell")
        ChatTable.delegate   = self
        ChatTable.dataSource = self
        ChatTable.tableFooterView = UIView()

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Notification")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        ChatTable.addSubview(refreshControl)
       
        self.RestAPiMethod()
        
   
     
    
        
        
    }
    
    func refresh(sender:AnyObject) {
        self.triggerNotification()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
      self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
     
    }
   
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChatCell
      
        let model = chatArr [indexPath.item] as! [ChatModel]

        cell.NameText.text?  = model[0].user_name
        cell.EmailText.text? = model[0].contact_no
        
        //**** Convert Image String into URl
       // let remoteImageUrlString = userimage[indexPath.item] as! String
        cell.IMG.sd_setImage(with: URL(string: "remoteImageUrlString"), placeholderImage: UIImage(named: "user-images.png"))
        
        return cell
    }
    /*** cell is tapped ***/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        //*** -->>Push to Chat Screen
        let vc = InboxchatController()
        let model = chatArr [indexPath.item] as! [ChatModel]
        
        vc.r_userid = model[0].user_id
        vc.r_username = model[0].user_name
        vc.r_userimage =  ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
   
    func RestAPiMethod() {
        
        /***SHOW HUD***/
        DispatchQueue.main.async {
            showHUD(to_view: self.view)
        }
        
        let s_id = Helper.Instance.getUserDefalultValueFor(key: KEYS.UserId)
        ParamsDict =  ["user_id": s_id]
        
        let dict = ParamsDict.prettyPrintJSON() as! Dictionary<String, String>
        
        if RestApi.Instance.isReachable(){
            
            
            RestApi.Instance.postService(content_type: REQUEST_HEADER.json, WebAPI: Api.GetallActiveUser, parameters: dict, helperCompletionHandler: { (response) in
                
                /***HIDE HUD***/
                DispatchQueue.main.async {
                    hideHUD(for_view: self.view)
                }
                
                let dict = response as! NSDictionary
                
                let status = dict.object(forKey: "status") as! Bool
                let MSG    = dict.object(forKey: "Msg") as! String
                
                if status as Bool == true {
                    
                    let data = dict.object(forKey: "Data") as! NSArray
                    chatArr = []
                    for item in data{
                        let model = [ChatModel.init(item as! Dictionary<String, AnyObject>)]
                        chatArr.append(model)
                    }
                    self.ChatTable.reloadData()
                    
                }else{
                    self.alert(message: MSG)
                }
                
            })
            
        }else{
            self.alert(message: Message.INTERNET_CONNECTIVITY)
        }
    }
    
    
    
    
    
   
    func triggerNotification(){
        
          let  notiDict =   ["s_id": "2",
                            "r_id": "3",
                            "title" : "W3Chat Notifications",
                            "subtitle":"Successfully deliver",
                            "body":"ARYAN ARYAN ARYAN"
                            ]
        
        print("notification  triggered ")
        let content = UNMutableNotificationContent()
        content.title = "W3Chat Notifications"
        content.subtitle = "Successfully deliver"
        content.body = "ARYAN ARYAN ARYAN"
        content.userInfo = notiDict
        content.sound = UNNotificationSound.default()
        
        //To Present image in notification
        if let path = Bundle.main.path(forResource: "logo", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("attachment not found.")
            }
        }
        
        // Deliver the notification 
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.50, repeats: false)
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                //print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func stopNotification(_ sender: AnyObject) {
        
        print("Removed all pending notifications")
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
    }
}

extension ChatVC:UNUserNotificationCenterDelegate{
    
 
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        print("User Info2 = ",response.notification.request.content.userInfo)
        completionHandler()
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
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
