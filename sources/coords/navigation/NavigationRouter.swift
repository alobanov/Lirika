// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import UIKit

public extension Router where RootContainer: LirikaNavigation {
  func container() -> LirikaNavigation.Container {
    return rootController?.container ?? LirikaNavigation.Container()
  }

  func push(_ viewController: Presentable, completion: PresentationHandler? = nil) {
    let controller = unwrapPresentable(viewController)
    wrapAnimation(animation: { [weak self] in
      guard let base = self else { return }
      base.container().pushViewController(controller, animated: true)
    }, completion: completion)
  }

  func pop(toRoot: Bool = false, completion: PresentationHandler? = nil, animated: Bool = true) {
    wrapAnimation(animation: { [weak self] in
      guard let base = self else { return }
      if toRoot {
        base.container().popToRootViewController(animated: animated)
      } else {
        base.container().popViewController(animated: animated)
      }
    }, completion: completion)
  }

  func set(_ viewControllers: [Presentable], animated: Bool, completion: PresentationHandler? = nil, barHidden: Bool = false) {
    let controllers = unwrapPresentables(viewControllers)
    wrapAnimation(animation: { [weak self] in
      guard let base = self else { return }
      base.container().setViewControllers(controllers, animated: animated)
      base.container().isNavigationBarHidden = barHidden
    }, completion: completion)
  }

  func setImmediately(_ modules: [Presentable]) {
    set(modules, animated: false, completion: nil, barHidden: false)
  }
  
  func pop(toPresentId: String, completion: PresentationHandler? = nil) {
    if let controller = controllerByPresentableId(toPresentId) {
      wrapAnimation(animation: { [weak self] in
        guard let base = self else { return }
        base.container().popToViewController(controller, animated: true)
      }, completion: completion)
    }
  }
  
  func controllerByPresentableId(_ id: String) -> UIViewController? {
    return rootController?.container.viewControllers.first(where: { $0.presentId() == id })?.presentable()
  }

  func pop(to viewController: Presentable, completion: PresentationHandler? = nil) {
    let controller = unwrapPresentable(viewController)
    wrapAnimation(animation: { [weak self] in
      guard let base = self else { return }
      base.container().popToViewController(controller, animated: true)
    }, completion: completion)
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
