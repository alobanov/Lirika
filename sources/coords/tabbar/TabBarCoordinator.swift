// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import UIKit

public class LirikaTabBar: LirikaRootContaierType {
  public func addCoordinator(_ coordinator: Coordinatorable) {}
  public func removeCoordinator(_ coordinator: Coordinatorable?) {}
  
  public var container: LirikaTabBar.Container
  open class Container: UITabBarController {}

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
