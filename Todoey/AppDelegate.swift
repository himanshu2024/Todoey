//
//  AppDelegate.swift
//  Todoey
//
//  Created by Himanshu Chaurasiya on 18/08/19.
//  Copyright © 2019 HPC. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        do{
            _ = try Realm()
        }
        catch{
            print("realm init error \(error)")
        }
        return true
    }

}

