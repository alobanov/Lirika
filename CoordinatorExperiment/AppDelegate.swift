// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  private var appCoordinator: AppCoordinator = {
    let coord = AppCoordinator(container: LirikaWindow(container: LirikaWindow.Container()), initialRoute: .options)
    return coord
  }() 

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Appearance.apply()
    appCoordinator.start()
    return true
  }
}
