// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class NavigationCoordinator<RouteType: Route>: Coordinator<RouteType, NavigationRouter> {
  override func generateRootViewController() -> LirikaNavigation {
    return LirikaNavigation(container: nil)
  }

  deinit {
    print("Dead NavigationCoordinator")
  }
}
