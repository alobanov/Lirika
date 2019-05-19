// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class LirikaWindow: LirikaRootContaierType {
  class RootContainer: UIWindow {}

  private let container: RootContainer
  init(container: RootContainer) {
    self.container = container
  }

  func rootContainer() -> RootContainer {
    return container
  }
}

typealias LirikaRouter = Router<LirikaWindow>

class WindowCoordinator<RouteType: Route>: Coordinator<RouteType, LirikaRouter> {
  override func generateRootViewController() -> LirikaWindow {
    return LirikaWindow(container: LirikaWindow.RootContainer())
  }
}
