// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

public typealias PresentationHandler = () -> Void

protocol RouterProtocol {
  associatedtype RootViewController: UIViewController
}

class Router<RootViewController: UIViewController>: RouterProtocol {
  weak var rootController: RootViewController?

  func define(root: RootViewController) {
    rootController = root
  }

  func unwrapPresentables(_ modules: [Presentable]) -> [UIViewController] {
    let controllers = modules.map { module -> UIViewController in
      unwrapPresentable(module)
    }
    return controllers
  }

  func unwrapPresentable(_ module: Presentable) -> UIViewController {
    let controller = module.presentable()
    if controller is UINavigationController {
      assertionFailure("Forbidden push UINavigationController.")
    }
    return controller
  }

  // MARK: - Presentable

  func presentable() -> UIViewController {
    return rootController!
  }

  func presentId() -> String {
    return rootController!.presentId()
  }

  static func presentId() -> String {
    return UINavigationController.presentId()
  }

  deinit {
    print("Dead Router")
  }
}
