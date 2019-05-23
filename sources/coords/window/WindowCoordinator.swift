// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class LirikaWindow: LirikaRootContaierType {
  private(set) var container: LirikaWindow.Container
  class Container: UIWindow {}
  
  init(container: Container? = nil) {
    self.container = container ?? Container()
  }
}

typealias WindowRouter = Router<LirikaWindow>

class WindowCoordinator<RouteType: Route>: Coordinator<RouteType, WindowRouter> {
  override func generateRootContainer() -> LirikaWindow {
    return LirikaWindow(container: LirikaWindow.Container())
  }
}
