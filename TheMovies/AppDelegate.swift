//
//  AppDelegate.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import AlamofireNetworkActivityLogger
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.setRootViewController(MainConfiguration.setup(), options: UIWindow.TransitionOptions(direction: .fade, style: .easeInOut))

        let navBar = UINavigationBar.appearance()
        navBar.tintColor = Colors.lightBlue
        navBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Colors.darkBlue
        ]

        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // do something
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // do something
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // do something
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // do something
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // do something
    }
}
