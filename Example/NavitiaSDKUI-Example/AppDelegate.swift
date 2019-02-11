//
//  AppDelegate.swift
//  NavitiaSDKUI-Example
//
//  Copyright © 2018 kisio. All rights reserved.
//
import UIKit
import NavitiaSDKUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NavitiaSDKUI.shared.initialize(token: "")
        NavitiaSDKUI.shared.bundle = Bundle(identifier: "org.cocoapods.NavitiaSDKUI")
        NavitiaSDKUI.shared.mainColor = UIColor(red: 64.0/255, green: 149.0/255, blue: 142.0/255, alpha: 1)
        NavitiaSDKUI.shared.originColor = UIColor(red: 0, green: 187.0/255, blue: 117.0/255, alpha: 1)
        NavitiaSDKUI.shared.destinationColor = UIColor(red: 176.0/255, green: 3.0/255, blue: 83.0/255, alpha: 1)
        NavitiaSDKUI.shared.multiNetwork = true
        NavitiaSDKUI.shared.formJourney = true
        
        return true
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
