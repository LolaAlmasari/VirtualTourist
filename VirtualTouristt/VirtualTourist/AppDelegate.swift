//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Lola M on 7/23/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dataController.shared.load()
        return true
    }
    
    func saveViewContext() {
        try?dataController.shared.viewContext.save()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveViewContext()
    }
}

