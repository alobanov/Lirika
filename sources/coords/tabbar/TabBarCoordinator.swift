// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

public class LirikaTabBar: LirikaRootContaierType {
  public var container: LirikaTabBar.Container
  public class Container: UITabBarController {}

  public init(container: Container? = nil) {
    self.container = container ?? Container()
  }
}

public typealias TabBarRouter = Router<LirikaTabBar>

open class TabBarCoordinator<RouteType: Route>: Coordinator<RouteType, TabBarRouter> {
  public convenience init(initialRoute: RouteType) {
    self.init(container: LirikaTabBar(), initialRoute: initialRoute)
  }
}
