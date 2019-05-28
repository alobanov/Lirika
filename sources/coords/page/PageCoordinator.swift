// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

protocol LirikaPageIndexProtocol {
  var index: Int { get }
}

class LirikaPage: LirikaRootContaierType {
  private(set) var container: LirikaPage.Container
  class Container: LirikaPageViewController {}

  init(container: Container? = nil) {
    self.container = container ?? Container(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }
}

typealias PageRouter = Router<LirikaPage>

class PageCoordinator<RouteType: Route>: Coordinator<RouteType, PageRouter> {
  convenience init() {
    self.init(container: LirikaPage())
  }
}
