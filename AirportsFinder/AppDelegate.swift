//
//  AppDelegate.swift
//  AirportsFinder
//
//  Created by CHERNANDER04 on 05/06/21.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("AIzaSyBuo6gF1-EkH8-X5EVBLVhV6XQt72YeG10")
        return true
    }

}

