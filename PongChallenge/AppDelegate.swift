//
//  AppDelegate.swift
//  PongChallenge
//
//  Created by Matthew Olson on 7/8/16.
//  Copyright © 2016 Molson. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow()
        
        let parseConfiguration = ParseClientConfiguration { (ParseMutableClientConfiguration) in
            ParseMutableClientConfiguration.applicationId = "APP_ID"
            ParseMutableClientConfiguration.clientKey = "CLIENT_KEY"
            ParseMutableClientConfiguration.server = "https://pong-challenge.herokuapp.com/parse"
        }
        
        Parse.initializeWithConfiguration(parseConfiguration)
        let rootView: UIViewController
        if PFUser.currentUser() != nil {
            let tabBar = UITabBarController()
            let challenges = ChallengesViewController()
            challenges.tabBarItem = UITabBarItem(title: "Open Challenges", image: UIImage(named: ""), tag: 0)
            tabBar.setViewControllers([challenges, UIViewController(), UIViewController()], animated: true) // TODO
            rootView = tabBar
        } else {
            rootView = LoginViewController()
        }
        
        
        
        if let window = self.window {
            window.rootViewController = rootView
            window.makeKeyAndVisible()
        }
        
        return true
    }

}

