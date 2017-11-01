//
//  AppDelegate.swift
//  W3Chat
//
//  Created by ios2 on 10/5/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,SSASideMenuDelegate ,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var navigationController = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        if isLoggedIn() !=  false {
            
            window = UIWindow(frame: UIScreen.main.bounds)
            
            //MARK : Setup SSASideMenu
            let newViewController = ChatVC()
            let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: newViewController), leftMenuViewController: LeftMenuViewController())
            sideMenu.backgroundImage = UIImage(named: "Background.jpg")
            sideMenu.configure(SSASideMenu.MenuViewEffect(fade: true, scale: true, scaleBackground: false))
            sideMenu.configure(SSASideMenu.ContentViewEffect(alpha: 1.0, scale: 0.7))
            sideMenu.configure(SSASideMenu.ContentViewShadow(enabled: true, color: UIColor.black, opacity: 0.6, radius: 6.0))
            sideMenu.delegate = self
            
            window?.rootViewController = sideMenu
            window?.makeKeyAndVisible()
            
        }else{
            let newViewController = LoginVC()
            let navigationController = UINavigationController(rootViewController: newViewController)
            self.window?.rootViewController = navigationController
            self.window!.makeKeyAndVisible()
            navigationController.setNavigationBarHidden(false, animated: true)
        }
        
            SetNavigationBar()
            registerForRemoteNotification()
        
        
        
/*****************************************************************/
/************************* FACEBOOK LOGIN ************************/
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func SetNavigationBar() -> Void{
        
        UINavigationBar.appearance().barTintColor = AppColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        UITextField.appearance().tintColor = AppColor
        UITextView.appearance().tintColor  = AppColor
        
        let navbarFont = UIFont(name: "Helvetica Neue", size: 17) ?? UIFont.systemFont(ofSize: 17)
        self.navigationController.navigationBar.titleTextAttributes = [ NSFontAttributeName: navbarFont]

        //*** ---> hide back bar button title
        //let BarButtonItemAppearance = UIBarButtonItem.appearance()
        //BarButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
  
    }
    
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    
  
    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    private func application(application: UIApplication,
                     openURL url: URL,
                     sourceApplication: String?,
                     annotation: Any?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
   
    
    
    
   
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        completionHandler()
    }
    
    
    
    


    
    
    func sideMenuWillShowMenuViewController(_ sideMenu: SSASideMenu, menuViewController: UIViewController) {
       // print("Will Show \(menuViewController)")
    }
    
    func sideMenuDidShowMenuViewController(_ sideMenu: SSASideMenu, menuViewController: UIViewController) {
        //print("Did Show \(menuViewController)")
    }
    
    func sideMenuDidHideMenuViewController(_ sideMenu: SSASideMenu, menuViewController: UIViewController) {
       // print("Did Hide \(menuViewController)")
    }
    
    func sideMenuWillHideMenuViewController(_ sideMenu: SSASideMenu, menuViewController: UIViewController) {
       // print("Will Hide \(menuViewController)")
    }
    func sideMenuDidRecognizePanGesture(_ sideMenu: SSASideMenu, recongnizer: UIPanGestureRecognizer) {
       // print("Did Recognize PanGesture \(recongnizer)")
    }
   
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        FBSDKAppEvents.activateApp()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }

//    // MARK: - Core Data stack
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "W3Chat")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                 
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
}

