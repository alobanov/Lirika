//
//  PageCoordinator.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 21/05/2019.
//  Copyright © 2019 Lobanov Aleksey. All rights reserved.
//

import UIKit

protocol LirikaPageIndexProtocol {
  var index: Int { get }
}

class LirikaPage: LirikaRootContaierType {
  class Container: LirikaPageViewController {}
  
  private let container: Container
  
  init(container: Container?) {
    self.container = container ?? Container()
  }
  
  func get() -> Container {
    return container
  }
}

typealias PageRouter = Router<LirikaPage>

class PageCoordinator<RouteType: Route>: Coordinator<RouteType, PageRouter> {
  override func generateRootContainer() -> LirikaPage {
    return LirikaPage(container: LirikaPage.Container())
  }
}

