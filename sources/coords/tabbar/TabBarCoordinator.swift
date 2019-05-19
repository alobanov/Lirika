// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class TabBarCoordinator<RouteType: Route>: Coordinator<RouteType, TabBarRouter> {
  override func generateRootContainer() -> LirikaTabBar {
    return LirikaTabBar(container: nil)
  }

  deinit {
    print("Dead TabBarCoordinator")
  }
}
