// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class LirikaNavigation: LirikaRootContaierType {
  class RootContainer: UINavigationController {}

  private let container: RootContainer
  init(container: RootContainer? = nil) {
    self.container = container ?? RootContainer()
  }

  func rootContainer() -> RootContainer {
    return container
  }
}

typealias NavigationRouter = Router<LirikaNavigation>

class NavigationCoordinator<RouteType: Route>: Coordinator<RouteType, NavigationRouter> {
  override func generateRootViewController() -> LirikaNavigation {
    return LirikaNavigation(container: nil)
  }

  deinit {
    print("Dead NavigationCoordinator")
  }
}
