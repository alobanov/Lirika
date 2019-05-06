// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

typealias NavigationRouter = Router<UINavigationController>

extension Router where RootViewController: UINavigationController {
  func push(_ viewController: Presentable, completion: PresentationHandler? = nil) {
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }
    
    rootController?.pushViewController(unwrapPresentable(viewController), animated: true)
    CATransaction.commit()
  }
  
  func pop(toRoot: Bool = false, completion: PresentationHandler? = nil, animated: Bool = true) {
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }
    
    if toRoot {
      rootController?.popToRootViewController(animated: animated)
    } else {
      rootController?.popViewController(animated: animated)
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
    rootController?.setViewControllers(controllers, animated: animated)
    rootController?.isNavigationBarHidden = barHidden
    
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
    
    rootController?.popToViewController(unwrapPresentable(viewController), animated: true)
    
    CATransaction.commit()
  }
  
  func presentModal(_ module: Presentable, animated: Bool, completion: (() -> Void)?) {
    DispatchQueue.main.async { [weak self] in
      self?.rootController?.present(module.presentable(), animated: animated, completion: completion)
    }
  }
  
  func dismissModalImmediately() {
    rootController?.dismiss(animated: false, completion: nil)
  }
  
  func dismissModal(animated: Bool, completion: (() -> Void)?) {
    rootController?.dismiss(animated: animated, completion: completion)
  }
  
  func push(_ modules: [Presentable], after: PresentableID, animated: Bool) {
    guard var stack = rootController?.viewControllers else {
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
      rootController?.setViewControllers(stack, animated: animated)
    }
  }
  
  func activePresentableID() -> String? {
    if let current = rootController?.topViewController as? UITabBarController {
      return (current.selectedViewController as? UINavigationController)?.visibleViewController?.presentId()
    } else {
      return rootController?.visibleViewController?.presentId()
    }
  }
  
  func activeController() -> UIViewController? {
    if let current = rootController?.topViewController as? UITabBarController {
      return (current.selectedViewController as? UINavigationController)?.visibleViewController
    } else {
      return rootController?.visibleViewController
    }
  }
}
