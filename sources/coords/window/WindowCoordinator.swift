// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

public class LirikaWindow: LirikaRootContaierType {
  public var container: LirikaWindow.Container
  public class Container: UIWindow {}

  public init(container: Container? = nil) {
    self.container = container ?? Container()
  }
}

public typealias WindowRouter = Router<LirikaWindow>

open class WindowCoordinator<RouteType: Route>: Coordinator<RouteType, WindowRouter> {
  public convenience init(initialRoute: RouteType) {
    self.init(container: LirikaWindow(), initialRoute: initialRoute)
  }
}
