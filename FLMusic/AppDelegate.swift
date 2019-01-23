//
//  AppDelegate.swift
//  fl_music_ios
//
//  Created by fengli on 2019/1/16.
//  Copyright © 2019 fengli. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        setting()
        if let token = getToken() {
            NetworkManager.instance.token = token
            
            
            let main = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = main.instantiateInitialViewController()
        } else {
            
            let login = UIStoryboard(name: "Login", bundle: nil)
            window?.rootViewController = login.instantiateInitialViewController()
        }
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func setting() {
        UISetting()
        otherSetting()
    }
    
    func UISetting() {
        
        UINavigationBar.appearance().barTintColor = kSecondTintColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white, .font : kBFont(size: 16)]
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: kNFont(size: 16), .foregroundColor: UIColor.white], for: .normal)
    }
    
    func otherSetting() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
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

