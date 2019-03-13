//
//  AppDelegate.swift
//  Xplore
//
//  Created by Jack Knight on 2/5/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        do {
            _ = try Realm()
        } catch {
            print("Error installing realm to project \(error)")
        }
        return true
    }
}

