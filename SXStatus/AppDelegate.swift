//
//  AppDelegate.swift
//  SXStatus
//
//  Created by Mark Malstrom on 3/12/17.
//  Copyright © 2017 Tangaroa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: ViewController())
        (self.window?.rootViewController as! UINavigationController).navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.05098039216, blue: 0.05098039216, alpha: 1)
        self.window?.makeKeyAndVisible()
                
        return true
    }

}

