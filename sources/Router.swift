// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

public typealias PresentationHandler = () -> Void

public protocol RouterProtocol {
  associatedtype RootContainer: LirikaRootContaierType
}

public class Router<RootContainer: LirikaRootContaierType>: RouterProtocol {
  public weak var rootController: RootContainer?

  public func define(root: RootContainer) {
    rootController = root
  }

  public func unwrapPresentables(_ modules: [Presentable]) -> [UIViewController] {
    let controllers = modules.map { module -> UIViewController in
      unwrapPresentable(module)
    }
    return controllers
  }

  public func unwrapPresentable(_ module: Presentable) -> UIViewController {
    let controller = module.presentable()
    return controller
  }

  // MARK: - Presentable

  public func presentable() -> UIViewController {
    guard let controller = rootController?.container else {
      return UIViewController()
    }

    switch controller {
    case let vc as UIViewController: return vc
    case let nvc as UINavigationController: return nvc
    case let tbc as UITabBarController: return tbc
    case let pvc as UIPageViewController: return pvc
    default: return UIViewController()
    }
  }

  public func presentId() -> String {
    return presentable().presentId()
  }
}
