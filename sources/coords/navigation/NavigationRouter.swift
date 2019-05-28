// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

extension Router where RootContainer: LirikaNavigation {
  func container() -> LirikaNavigation.Container {
    return rootController?.container ?? LirikaNavigation.Container()
  }

  func push(_ viewController: Presentable, completion: PresentationHandler? = nil) {
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }

    container().pushViewController(unwrapPresentable(viewController), animated: true)
    CATransaction.commit()
  }

  func pop(toRoot: Bool = false, completion: PresentationHandler? = nil, animated: Bool = true) {
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }

    if toRoot {
      container().popToRootViewController(animated: animated)
    } else {
      container().popViewController(animated: animated)
    }
    CATransaction.commit()
  }

  func set(_ viewControllers: [Presentable],
           animated: Bool,
           completion: PresentationHandler? = nil,
           barHidden: Bool = false) {
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }

    let controllers = unwrapPresentables(viewControllers)
    container().setViewControllers(controllers, animated: animated)
    container().isNavigationBarHidden = barHidden

    CATransaction.commit()
  }

  func setImmediately(_ modules: [Presentable]) {
    set(modules, animated: false, completion: nil, barHidden: false)
  }

  func pop(to viewController: Presentable,
           completion: PresentationHandler? = nil) {
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }

    container().popToViewController(unwrapPresentable(viewController), animated: true)

    CATransaction.commit()
  }

  func presentModal(_ module: Presentable, animated: Bool, completion: (() -> Void)?) {
    DispatchQueue.main.async { [weak self] in
      self?.container().present(module.presentable(), animated: animated, completion: completion)
    }
  }

  func dismissModalImmediately() {
    container().dismiss(animated: false, completion: nil)
  }

  func dismissModal(animated: Bool, completion: (() -> Void)?) {
    container().dismiss(animated: animated, completion: completion)
  }

  func push(_ modules: [Presentable], after: PresentableID, animated: Bool) {
    guard var stack = rootController?.container.viewControllers else {
      return
    }

    let viewController = stack.first(
      where: { controller -> Bool in
        controller.presentId() == after
      }
    )

    if let controller = viewController {
      while true {
        if stack.isEmpty { break }
        if let current = stack.last {
          if current == controller {
            break
          } else {
            stack.removeLast()
          }
        }
      }

      let controllers = unwrapPresentables(modules)
      stack += controllers
      container().setViewControllers(stack, animated: animated)
    }
  }

  func activePresentableID() -> String? {
    if let current = rootController?.container.topViewController as? UITabBarController {
      return (current.selectedViewController as? UINavigationController)?.visibleViewController?.presentId()
    } else {
      return container().visibleViewController?.presentId()
    }
  }

  func activeController() -> UIViewController? {
    if let current = rootController?.container.topViewController as? UITabBarController {
      return (current.selectedViewController as? UINavigationController)?.visibleViewController
    } else {
      return container().visibleViewController
    }
  }
}
