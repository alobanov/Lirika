// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  private lazy var coordinator = AppCoordinator(container: LirikaWindow(container: LirikaWindow.Container()), initialRoute: .options)

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Appearance.apply()
    coordinator.start()
    return true
  }
}
