//
//  AppDelegate.swift
//  ArroundTheWorld
//
//  Created by Алексей Плотников on 05.10.2023.
//

import UIKit
import AppMetricaCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?
    var appCoordinator:AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let configuration = AppMetricaConfiguration(apiKey: "8c5755bd-e5cc-48c2-8c4d-8ad1f567b6b0")
           AppMetrica.activate(with: configuration!)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationCon = UINavigationController.init()
        appCoordinator = AppCoordinator(navigationController: navigationCon)
        appCoordinator!.start()
        window!.rootViewController = navigationCon
        window?.overrideUserInterfaceStyle = .light
        window!.makeKeyAndVisible()
        
        return true
    }

   

}

