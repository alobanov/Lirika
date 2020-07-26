// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import UIKit

public class MyRootModalNavigationContainer: LirikaNavigation.Container {
  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.removeCoordinator(nil)
  }
}

public class LirikaNavigation: LirikaRootContaierType {
  
  public var container: LirikaNavigation.Container
  open class Container: UINavigationController {}

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
