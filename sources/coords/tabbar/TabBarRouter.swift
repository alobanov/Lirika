// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class LirikaTabBar: LirikaRootContaierType {
  class RootContainer: UITabBarController {}
  
  private let container: RootContainer
  init(container: RootContainer?) {
    self.container = container ?? RootContainer()
  }
  
  func rootContainer() -> RootContainer {
    return container
  }
}


typealias TabBarRouter = Router<LirikaTabBar>

extension Router where RootViewController: LirikaTabBar {
  func set(_ viewControllers: [Presentable], animated: Bool, completion: PresentationHandler?) {
    let controllers = unwrapPresentables(viewControllers)
    
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    
    rootController?.rootContainer().setViewControllers(controllers, animated: animated)
    
    CATransaction.commit()
  }
  
  func select(index: Int, completion: PresentationHandler?) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    
    rootController?.rootContainer().selectedIndex = index
    
    CATransaction.commit()
  }
}
