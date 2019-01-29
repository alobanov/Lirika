//
//  TabBarCoordinator.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 26/01/2019.
//  Copyright © 2019 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit

typealias TabBarRouter = Router<UITabBarController>

extension Router where RootViewController: UITabBarController {
  func set(_ viewControllers: [UIViewController],
           completion: PresentationHandler?) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    
    rootController?.setViewControllers(viewControllers, animated: true)
    
    CATransaction.commit()
  }
  
  func select(index: Int, completion: PresentationHandler?) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    
    rootController?.selectedIndex = index
    
    CATransaction.commit()
  }
}

class TabBarCoordinator<RouteType: Route>: Coordinator<RouteType, TabBarRouter> {
  init(rootViewController: UITabBarController? = nil, initialRoute: RouteType) {
    super.init(controller: rootViewController, initialRoute: initialRoute)
  }
  
  override func generateRootViewController() -> UITabBarController {
    return super.generateRootViewController()
  }
  
  deinit {
    print("Dead TabBarCoordinator")
  }
}
