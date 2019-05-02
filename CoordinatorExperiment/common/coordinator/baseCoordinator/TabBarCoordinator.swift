// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import UIKit

typealias TabBarRouter = Router<UITabBarController>

extension Router where RootViewController: UITabBarController {
  func set(_ viewControllers: [UIViewController], animated: Bool,
           completion: PresentationHandler?) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)

    rootController?.setViewControllers(viewControllers, animated: animated)

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
//  override func generateRootViewController() -> UITabBarController {
//    return super.generateRootViewController()
//  }

  deinit {
    print("Dead TabBarCoordinator")
  }
}
