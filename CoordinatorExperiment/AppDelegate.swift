// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//  let window: UIWindow! = UIWindow()
  private lazy var appCoordinator: AppCoordinator = self.coordinator()

  func coordinator() -> AppCoordinator {
    return AppCoordinator(controller: LirikaWindow(container: LirikaWindow.RootContainer()), initialRoute: .options)
  }

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Appearance.apply()
    appCoordinator.start()
    return true
  }
}
