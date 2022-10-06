//
//  AppDelegate.swift
//  Compan
//
//  Created by Ambu Sangoli on 25/04/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var logoutView : LogoutView?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if self.logoutView == nil {
            self.logoutView = Bundle.main.loadNibNamed("LogoutView", owner:
            self, options: nil)?.first as? LogoutView
            self.logoutView?.tag = 111
            self.logoutView?.frame = CGRect(x: UIScreen.main.bounds.maxX - 90, y: 40, width: 80, height: 40)
            self.logoutView?.layer.cornerRadius = 20
            self.logoutView?.isUserInteractionEnabled = true
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

