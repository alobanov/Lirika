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
  func push(_ viewController: Presentable,
            completion: PresentationHandler? = nil) {
    
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }
    
    self.rootController?.pushViewController(unwrapPresentable(viewController), animated: true)
    
    CATransaction.commit()
  }
  
  func pop(toRoot: Bool, completion: PresentationHandler? = nil) {
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }
    
    if toRoot {
      self.rootController?.popToRootViewController(animated: true)
    } else {
      self.rootController?.popViewController(animated: true)
    }
    
    CATransaction.commit()
  }
  
  func set(_ viewControllers: [Presentable],
           completion: PresentationHandler? = nil, barHidden: Bool = false) {
    
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }
   
    let controllers = unwrapPresentables(viewControllers)
    self.rootController?.setViewControllers(controllers, animated: false)
    self.rootController?.isNavigationBarHidden = barHidden
    
//    let controllers = unwrapPresentables(viewControllers)
//    let stack = rootController!.viewControllers + controllers
//    self.rootController?.setViewControllers(stack, animated: false)
//    self.rootController?.isNavigationBarHidden = barHidden
    
    CATransaction.commit()
  }
  
  func pop(to viewController: Presentable,
           completion: PresentationHandler? = nil) {
    
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion?()
    }
    
    self.rootController?.popToViewController(unwrapPresentable(viewController), animated: true)
    
    CATransaction.commit()
  }
}

class NavigationCoordinator<RouteType: Route>: Coordinator<RouteType, NavigationRouter> {
  init(window: UIWindow, initialRoute: RouteType) {
    super.init(controller: nil, initialRoute: initialRoute)
    self.window = window
    setRoot(for: window)
  }
  
  init(rootViewController: UINavigationController? = nil, initialRoute: RouteType) {
    super.init(controller: rootViewController, initialRoute: initialRoute)
  }
  
  override func generateRootViewController() -> UINavigationController {
    return super.generateRootViewController()
  }
  
  deinit {
    print("Dead NavigationCoordinator")
  }
}
