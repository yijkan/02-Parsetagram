//
//  AppDelegate.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/20/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // string constants
    let appId = "Parsetagram"
    let clientKey = "YK-MasterKey"
    let server = "https://mighty-falls-98851.herokuapp.com/parse"
    let mainVC = "Main"
    let loginVC = "Login"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize Parse
        // Set applicationId and server based on the values in the Heroku settings.
        // clientKey is not used on Parse open source unless explicitly configured
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = self.appId
                configuration.clientKey =  self.clientKey // set to nil assuming you have not set clientKey
                configuration.server = self.server
                
            })
        )
        
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        /*** change tab bar and navigation bar colors ***/
        UITabBar.appearance().tintColor = tintColor
        UITabBar.appearance().barTintColor = barColor
        UINavigationBar.appearance().barTintColor = barColor
        
        // to determine whether user is logged in and present a view controller depending on that
        let viewController : UIViewController?
        if PFUser.currentUser() != nil {
            viewController = storyBoard.instantiateViewControllerWithIdentifier(mainVC) as UIViewController
        } else {
            viewController = storyBoard.instantiateViewControllerWithIdentifier(loginVC) as UIViewController
        }
        self.window?.rootViewController = viewController!
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

