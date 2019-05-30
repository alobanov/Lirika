// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

public protocol LirikaPageIndexProtocol {
  var index: Int { get }
}

public class LirikaPage: LirikaRootContaierType {
  public var container: LirikaPage.Container
  open class Container: LirikaPageViewController {}

  public init(container: Container? = nil) {
    self.container = container ?? Container(style: .scroll, orientation: .horizontal)
  }
}

public typealias PageRouter = Router<LirikaPage>

open class PageCoordinator<RouteType: Route>: Coordinator<RouteType, PageRouter> {
  public convenience init() {
    self.init(container: LirikaPage())
  }
}
