//
//  WindowCoordinator.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/05/2019.
//  Copyright © 2019 Lobanov Aleksey. All rights reserved.
//

import UIKit

protocol LirikaRootContaierType: class {
  associatedtype RootContainer
  func rootContainer() -> RootContainer
}

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

extension Router where RootViewController: LirikaWindow {
  func setRootCoordinator(controller: UIViewController) {
    rootController?.rootContainer().rootViewController = controller
  }
}

class WindowCoordinator<RouteType: Route>: Coordinator<RouteType, LirikaRouter> {
  override func generateRootViewController() -> LirikaWindow {
    return LirikaWindow(container: LirikaWindow.RootContainer())
  }
}
