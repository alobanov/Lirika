// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

public class LirikaController: LirikaRootContaierType {
  public var container: LirikaController.Container
  public class Container: UIViewController {}

  public init(container: Container? = nil) {
    self.container = container ?? Container()
  }
}

public typealias ControllerRouter = Router<LirikaController>

open class ControllerCoordinator<RouteType: Route>: Coordinator<RouteType, ControllerRouter> {
  public convenience init() {
    self.init(container: LirikaController())
  }
}
