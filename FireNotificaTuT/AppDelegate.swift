//
//  AppDelegate.swift
//  FireNotificaTuT
//
//  Created by Sukumar Anup Sukumaran on 09/05/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error == nil {
                print("Successful Authorization")
            }
            
        }
        
        // allow our application to send remote notifications
        // Override point for customization after application launch.
        //create the notificationCenter
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//
//            let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
//            DispatchQueue.main.asyncAfter(deadline: when) {
//                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//                UNUserNotificationCenter.current().requestAuthorization(
//                    options: authOptions,
//                    completionHandler: {_, _ in })
//            }
//
//            // For iOS 10 data message (sent via FCM)
//            //FIRMessaging.messaging().remoteMessageDelegate = self
//
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//
//        }
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
         UIApplication.shared.applicationIconBadgeNumber = 0
        FBHandler()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @objc func refreshToken(notification: NSNotification) {
        let refreshToken = InstanceID.instanceID().token()!
        print("Refreshtoken = \(refreshToken) ")
        FBHandler()
    }

    func FBHandler() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Registration succeeded! Token: ", token)
    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Registration failed!")
//    }
//
//    // Firebase notification received
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
//
//        // custom code to handle push while app is in the foreground
//        print("Handle push from foreground\(notification.request.content.userInfo)")
//
//        let dict = notification.request.content.userInfo["aps"] as! NSDictionary
//        let d : [String : Any] = dict["alert"] as! [String : Any]
//        let body : String = d["body"] as! String
//        let title : String = d["title"] as! String
//        print("Title:\(title) + body:\(body)")
//        self.showAlertAppDelegate(title: title, message:body, buttonTitle:"ok", window:self.window!)
//        // showAlertTest()
//    }
//
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
//        print("Handle push from background or closed\(response.notification.request.content.userInfo)")
//    }
//
//    func showAlertAppDelegate(title: String, message : String,buttonTitle: String, window: UIWindow){
//        print("ALERTHere = title = \(title), message = \(message), bitton title = \(buttonTitle)")
//        let topWindow = UIWindow(frame: UIScreen.main.bounds)
//        topWindow.rootViewController = UIViewController()
//        topWindow.windowLevel = UIWindowLevelAlert + 1
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
//        topWindow.makeKeyAndVisible()
//        topWindow.rootViewController?.present(alert, animated: true, completion: nil)
//    }

}

