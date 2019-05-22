// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

extension Router where RootContainer: LirikaTabBar {
  func container() -> LirikaTabBar.Container {
    return rootController?.get() ?? LirikaTabBar.Container()
  }
  
  func set(_ viewControllers: [Presentable], animated: Bool, completion: PresentationHandler?) {
    let controllers = unwrapPresentables(viewControllers)

    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)

    container().setViewControllers(controllers, animated: animated)

    CATransaction.commit()
  }

  func select(index: Int, completion: PresentationHandler?) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)

    container().selectedIndex = index

    CATransaction.commit()
  }
}
