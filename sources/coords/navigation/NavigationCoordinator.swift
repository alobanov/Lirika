// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class NavigationCoordinator<RouteType: Route>: Coordinator<RouteType, NavigationRouter> {
  override func generateRootViewController() -> UINavigationController {
    return super.generateRootViewController()
  }

  deinit {
    print("Dead NavigationCoordinator")
  }
}
