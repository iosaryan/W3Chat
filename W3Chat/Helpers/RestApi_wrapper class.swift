//
//  RestApi_wrapper class.swift
//  W3Chat
//
//  Created by ios2 on 25/9/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration




/*****************************************************************/
/************************* LIVE URL **************************/

//private let BaseURL = "https://projects.w3care.net/w3api/api.php?method=/"
/**************************** END *********************************/



/********************************************************************/
/************************* STAGING URL **************************/

private let BaseURL = "https://projects.w3care.net/w3api/api.php?method="
/**************************** END ************************************/

struct REQUEST_HEADER {
    
    static let urlencoded = "application/x-www-form-urlencoded"
    static let json       = "application/json"
    
   
    
    
}

struct  Api{
    
/*******************************************************************/
/************************* API METHOD KEY ***************************/
    
    static let SignUp           = "\(BaseURL)sign_up"
    static let Login            = "\(BaseURL)user_login"
    static let GetallActiveUser = "\(BaseURL)GetallActiveUser"
    static let sendMsgapi       = "\(BaseURL)sendMsgapi"
    static let ChatfromServer   = "\(BaseURL)getAllChatFromServer"
    static let recvMsgapi       = "\(BaseURL)recieveMsgapi"
    
/**************************** END ************************************/

}


/*******************************************************************/
/*********************  REST API METHOD  ***************************/
/*********************  REST API METHOD  ***************************/
/*********************  REST API METHOD  ***************************/
/*********************  REST API METHOD  ***************************/
/*******************************************************************/

class RestApi{
    
    //MARK: VARIABLES
    private static let _instance = RestApi();
    private init() {}
    
    static var Instance: RestApi {
        return _instance;
    }
    
    
    
    
    func isReachable() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    
    
    func postService(content_type:String,WebAPI:String, parameters:Dictionary<String, String> ,helperCompletionHandler: @escaping(_ json:Any) -> Void)->Void
    {
        
        let headers: HTTPHeaders = ["Content-Type" : content_type]
        
        Alamofire.request(WebAPI, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {
            response in
            
            do{
                //JSONSerialization.ReadingOptions.mutableContainers
                //JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                helperCompletionHandler(json)
            }
            catch
            {
                let json = ["success" : false] as NSDictionary
                
                print(error)
                helperCompletionHandler(json)
                
                //false
            }
            
        })
        
    }
    
    func getService(content_type:String,WebAPI:String, helperCompletionHandler: @escaping(_ json:Any) -> Void)->Void
    {
        
        let headers: HTTPHeaders = ["Content-Type" : content_type]
        
        Alamofire.request(WebAPI, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {
            response in
            
            do{
                let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                //print("json = \(json)")
                
                helperCompletionHandler(json)
            }
            catch
            {
                let json = ["success" : false] as NSDictionary
                
                print(error)
                helperCompletionHandler(json)
            }
        })
    }
    
    func multiPartFormDataWithoutImageServiceWith(url : String  ,methodParameters : NSDictionary,helperCompletionHandler: @escaping(_ json:Any) -> Void)->Void {
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                
                for (key, value) in methodParameters {
                    
                    //print("key=\(key)")
                    // print("value=\(value)")
                    MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                }
                
        },  to: url) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                
                upload.responseJSON(completionHandler: { (response ) in
                    // print(response.result.value as Any)
                    
                    if (response.result.value == nil){
                        
                        var json:NSDictionary = NSDictionary()
                        
                        json = [
                            "success" : false
                        ]
                        
                        helperCompletionHandler(json)
                        
                    }else{
                        helperCompletionHandler(response.result.value as! NSDictionary)
                        
                    }
                })
                break
                
            case .failure(let encodingError):
                print(encodingError)
                
                break
            }
        }
    }
    
    
    
    func multiPartFormDataService(imgData : Data,methodParameters : NSDictionary,methodURL : String ,helperCompletionHandler: @escaping(_ json:Any) -> Void)->Void {
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                
                for (key, value) in methodParameters {
                    
                    print("key=\(key)")
                    print("value=\(value)")
                    MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                }
                
                if (imgData != nil){
                    MultipartFormData.append((imgData), withName: "image_file", fileName: "user.jpeg", mimeType: "image/jpeg")
                    // print("MultipartFormData=\(MultipartFormData)")
                    
                }else{
                    
                    print("NO Image")
                    
                }
                
        },  to: methodURL) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                
                upload.responseJSON(completionHandler: { (response ) in
                    print(response.result.value as Any)
                    
                    
                    if response.result.value == nil {
                        
                        var json:NSDictionary = NSDictionary()
                        
                        
                        json = [
                            "success" : false
                        ]
                        
                        helperCompletionHandler(json)
                        
                    }else{
                        
                        let dict = response.result.value as! NSDictionary
                        
                        if dict.value(forKey: "success")as! Bool == true {
                            
                            let json = response.result.value as Any
                            
                            helperCompletionHandler(json)
                            
                            
                        }else{
                            let json = response.result.value as Any
                            
                            helperCompletionHandler(json)
                            
                        }
                    }
                })
                break
                
            case .failure(let encodingError):
                print(encodingError)
                
                break
            }
        }
    }
}



