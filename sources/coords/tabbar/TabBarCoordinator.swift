// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class LirikaTabBar: LirikaRootContaierType {
  private(set) var container: LirikaTabBar.Container
  class Container: UITabBarController {}

  init(container: Container? = nil) {
    self.container = container ?? Container()
  }
}

typealias TabBarRouter = Router<LirikaTabBar>

class TabBarCoordinator<RouteType: Route>: Coordinator<RouteType, TabBarRouter> {
  convenience init(initialRoute: RouteType) {
    self.init(container: LirikaTabBar(), initialRoute: initialRoute)
  }
}
