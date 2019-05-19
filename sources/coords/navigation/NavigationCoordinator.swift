// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class LirikaNavigation: LirikaRootContaierType {
  class Container: UINavigationController {}

  private let container: Container
  init(container: Container? = nil) {
    self.container = container ?? Container()
  }

  func get() -> Container {
    return container
  }
}

typealias NavigationRouter = Router<LirikaNavigation>

class NavigationCoordinator<RouteType: Route>: Coordinator<RouteType, NavigationRouter> {
  override func generateRootContainer() -> LirikaNavigation {
    return LirikaNavigation(container: nil)
  }

  deinit {
    print("Dead NavigationCoordinator")
  }
}
