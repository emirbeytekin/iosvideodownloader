//
//  AppDelegate.swift
//  YtDownloader
//
//  Created by Emir Beytekin on 5.01.2017.
//  Copyright © 2017 Emir Beytekin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift
import UserNotifications
import OneSignal
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabBarController: UITabBarController?
    
    var appVersion = "1.3"
    
    var firstNC: UINavigationController!
    var secondsNC: UINavigationController!
    
    
    var firstVC: FirstViewController?
    var secondsVC: SecondViewController?
    
    var deviceId = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        Fabric.with([Crashlytics.self])
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "86dc1b48-5f85-4fd8-815a-020bcd213dae") { (result) in
            
            // This block gets called when the user reacts to a notification received
            
            let payload = result?.notification.payload
            let messageTitle = "OneSignal Example"
            var fullMessage = payload?.title
            
            //Try to fetch the action selected
            if let additionalData = payload?.additionalData, let actionSelected = additionalData["actionSelected"] as? String {
                fullMessage =  fullMessage! + "\nPressed ButtonId:\(actionSelected)"
            }
            
//            let alertView = UIAlertView(title: messageTitle, message: fullMessage, delegate: nil, cancelButtonTitle: "Close")
//            alertView.show()
        }
        
        //setting up view controllers and navigation controllers
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        
        firstVC = FirstViewController(nibName: "FirstViewController", bundle: nil)
        secondsVC = SecondViewController(nibName: "SecondViewController", bundle: nil)
        
        firstNC = UINavigationController(rootViewController: firstVC!)
        secondsNC = UINavigationController(rootViewController: secondsVC!)
        
        tabBarController = UITabBarController()
        tabBarController!.viewControllers = [firstNC!,
                                             secondsNC!]
        
        self.window?.rootViewController = tabBarController
        
        self.window?.makeKeyAndVisible()
        
        makeTabbarView()
        
        makeNavBars([firstNC , secondsNC])
        
        // Override point for customization after application launch.
        return true
    }
    
    func makeTabbarView()
    {
        
        let numberOfItems = CGFloat((tabBarController?.tabBar.items!.count)!)
        
        let tabBarItemSize = CGSize(width: (tabBarController?.tabBar.frame.width)! / numberOfItems,
                                    height: (tabBarController?.tabBar.frame.height)!)
        
        firstNC?.tabBarItem.image = UIImage(named: "i1")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        firstNC?.tabBarItem.selectedImage = UIImage(named: "i1h")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        firstNC.tabBarItem.title = "Download File"
        
        secondsNC?.tabBarItem.image = UIImage(named: "i2")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        secondsNC?.tabBarItem.selectedImage = UIImage(named: "i2h")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        secondsNC.tabBarItem.title = "My Library"
        
        self.tabBarController?.tabBar.tintColor = UIColor.uBlackColor()
        self.tabBarController?.tabBar.selectionIndicatorImage = UIImage().makeImageWithColorAndSize(color: UIColor.uNavBarActiveColor(), size: tabBarItemSize)
        
    }
    
    func makeNavBars(_ navControllers:NSArray) {
        
        for i in 0..<navControllers.count {
            let navController: UINavigationController = navControllers[i] as! UINavigationController
            customizeNavBar(navigationController: navController)
        }
    }
    
    func customizeNavBar(navigationController: UINavigationController) {
        
        navigationController.navigationBar.barTintColor = UIColor.uNavBarActiveColor()
        
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        navigationController.navigationBar.isTranslucent = false
        
        
        let font:UIFont = UIFont.fontWithSize(14, style: .fontStyleBook)
        
        let titleDict: [String: AnyObject] = [
            NSForegroundColorAttributeName: UIColor.black,
            NSFontAttributeName: font]
        
        navigationController.navigationBar.titleTextAttributes = titleDict
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        let keychain = KeychainSwift()
        keychain.set(deviceTokenString, forKey: "DEVICE_KEY")
        print(deviceTokenString)
        self.deviceId = deviceTokenString
//        self.saveDevice()
        
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
    }
    
    
}
extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        print(size.width)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}



