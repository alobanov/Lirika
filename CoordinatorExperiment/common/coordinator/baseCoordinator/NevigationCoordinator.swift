//
//  NevigationCoordinator.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 26/01/2019.
//  Copyright © 2019 Lobanov Aleksey. All rights reserved.
//

import Foundation
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
}

class NavigationCoordinator<RouteType: Route>: Coordinator<RouteType, NavigationRouter> {
//  override func generateRootViewController() -> UINavigationController {
//    return super.generateRootViewController()
//  }
  
  deinit {
    print("Dead NavigationCoordinator")
  }
}
