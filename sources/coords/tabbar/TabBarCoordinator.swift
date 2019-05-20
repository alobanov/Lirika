// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class LirikaTabBar: LirikaRootContaierType {
  class Container: UITabBarController {}
  
  private let container: Container
  
  init(container: Container?) {
    self.container = container ?? Container()
  }
  
  func get() -> Container {
    return container
  }
}

typealias TabBarRouter = Router<LirikaTabBar>

class TabBarCoordinator<RouteType: Route>: Coordinator<RouteType, TabBarRouter> {
  override func generateRootContainer() -> LirikaTabBar {
    return LirikaTabBar(container: nil)
  }
}
