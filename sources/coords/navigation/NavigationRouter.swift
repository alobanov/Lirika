// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

extension Router where RootContainer: LirikaNavigation {
  func push(_ viewController: Presentable, completion: PresentationHandler? = nil) {
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }

    rootController?.rootContainer().pushViewController(unwrapPresentable(viewController), animated: true)
    CATransaction.commit()
  }

  func pop(toRoot: Bool = false, completion: PresentationHandler? = nil, animated: Bool = true) {
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }

    if toRoot {
      rootController?.rootContainer().popToRootViewController(animated: animated)
    } else {
      rootController?.rootContainer().popViewController(animated: animated)
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
    rootController?.rootContainer().setViewControllers(controllers, animated: animated)
    rootController?.rootContainer().isNavigationBarHidden = barHidden

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

    rootController?.rootContainer().popToViewController(unwrapPresentable(viewController), animated: true)

    CATransaction.commit()
  }

  func presentModal(_ module: Presentable, animated: Bool, completion: (() -> Void)?) {
    DispatchQueue.main.async { [weak self] in
      self?.rootController?.rootContainer().present(module.presentable(), animated: animated, completion: completion)
    }
  }

  func dismissModalImmediately() {
    rootController?.rootContainer().dismiss(animated: false, completion: nil)
  }

  func dismissModal(animated: Bool, completion: (() -> Void)?) {
    rootController?.rootContainer().dismiss(animated: animated, completion: completion)
  }

  func push(_ modules: [Presentable], after: PresentableID, animated: Bool) {
    guard var stack = rootController?.rootContainer().viewControllers else {
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
      rootController?.rootContainer().setViewControllers(stack, animated: animated)
    }
  }

  func activePresentableID() -> String? {
    if let current = rootController?.rootContainer().topViewController as? UITabBarController {
      return (current.selectedViewController as? UINavigationController)?.visibleViewController?.presentId()
    } else {
      return rootController?.rootContainer().visibleViewController?.presentId()
    }
  }

  func activeController() -> UIViewController? {
    if let current = rootController?.rootContainer().topViewController as? UITabBarController {
      return (current.selectedViewController as? UINavigationController)?.visibleViewController
    } else {
      return rootController?.rootContainer().visibleViewController
    }
  }
}
