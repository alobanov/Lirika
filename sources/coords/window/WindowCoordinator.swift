// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class LirikaWindow: LirikaRootContaierType {
  class Container: UIWindow {}

  private let container: Container
  init(container: Container) {
    self.container = container
  }

  func get() -> Container {
    return container
  }
}

typealias LirikaRouter = Router<LirikaWindow>

class WindowCoordinator<RouteType: Route>: Coordinator<RouteType, LirikaRouter> {
  override func generateRootContainer() -> LirikaWindow {
    return LirikaWindow(container: LirikaWindow.Container())
  }
}
