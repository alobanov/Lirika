// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class LirikaNavigation: LirikaRootContaierType {
  private(set) var container: LirikaNavigation.Container
  class Container: UINavigationController {}
  
  init(container: Container? = nil) {
    self.container = container ?? Container()
  }
}

typealias NavigationRouter = Router<LirikaNavigation>

class NavigationCoordinator<RouteType: Route>: Coordinator<RouteType, NavigationRouter> {
  override func generateRootContainer() -> LirikaNavigation {
    return LirikaNavigation(container: nil)
  }
}
