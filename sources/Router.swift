// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

public typealias PresentationHandler = () -> Void

protocol RouterProtocol {
  associatedtype RootContainer: LirikaRootContaierType
}

class Router<RootContainer: LirikaRootContaierType>: RouterProtocol {
  weak var rootController: RootContainer?

  func define(root: RootContainer) {
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
    guard let controller = rootController?.container else {
      return UIViewController()
    }

    switch controller {
    case let vc as UIViewController: return vc
    case let nvc as UINavigationController: return nvc
    default: return UIViewController()
    }
  }

  func presentId() -> String {
    return presentable().presentId()
  }

  static func presentId() -> String {
    return UINavigationController.presentId()
  }
}
