// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  private lazy var coordinator = AppCoordinator(container: LirikaWindow(container: MyWindow()))

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Appearance.apply()
    coordinator.start()
    return true
  }
}
