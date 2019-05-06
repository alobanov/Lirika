// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class TabBarCoordinator<RouteType: Route>: Coordinator<RouteType, TabBarRouter> {
  override func generateRootViewController() -> UITabBarController {
    return super.generateRootViewController()
  }

  deinit {
    print("Dead TabBarCoordinator")
  }
}
