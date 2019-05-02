// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  let window: UIWindow! = UIWindow()
  private lazy var appCoordinator: AppCoordinator = self.coordinator()

  func coordinator() -> AppCoordinator {
    return AppCoordinator(window: window, initialRoute: .options)
  }

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    Appearance.apply()
    appCoordinator.start()

//    CommonHelper.delay(0.1) { [weak self] in
//      self?.appCoordinator.deepLink(link: SignupDeepLink())
//    }
    return true
  }
}
