// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

public typealias PresentationHandler = () -> Void

protocol RouterProtocol {
  associatedtype RootViewController: LirikaRootContaierType
}

class Router<RootViewController: LirikaRootContaierType>: RouterProtocol {
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
    return controller
  }

  // MARK: - Presentable

  func presentable() -> UIViewController {
    guard let controller = rootController?.rootContainer() else {
      return UIViewController()
    }
    
    switch controller {
    case let c as UIViewController:
      return c
    case let n as UINavigationController:
      return n
    default:
      return UIViewController()
    }
  }

  func presentId() -> String {
    return presentable().presentId()
  }

  static func presentId() -> String {
    return UINavigationController.presentId()
  }

  deinit {
    print("Dead Router")
  }
}
