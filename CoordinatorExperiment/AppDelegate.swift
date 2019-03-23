//
//  AppDelegate.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright © 2019 Lobanov Aleksey. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  let window: UIWindow! = UIWindow()
  private lazy var appCoordinator: AppCoordinator = self.coordinator()
  
  func coordinator() -> AppCoordinator {
    return AppCoordinator(window: window, initialRoute: .authorization)
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    Appearance.apply()
    appCoordinator.start()
    
//    CommonHelper.delay(0.1) { [weak self] in
//      self?.appCoordinator.deepLink(link: SignupDeepLink())
//    }
    return true
  }
}

