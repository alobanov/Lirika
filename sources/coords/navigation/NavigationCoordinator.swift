// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

public class LirikaNavigation: LirikaRootContaierType {
  public var container: LirikaNavigation.Container
  public class Container: UINavigationController {}

  public init(container: Container? = nil) {
    self.container = container ?? Container()
  }
}

public typealias NavigationRouter = Router<LirikaNavigation>

open class NavigationCoordinator<RouteType: Route>: Coordinator<RouteType, NavigationRouter> {
  public convenience init(initialRoute: RouteType) {
    self.init(container: LirikaNavigation(container: nil), initialRoute: initialRoute)
  }
}
