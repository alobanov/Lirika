// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

extension Router where RootContainer: LirikaTabBar {
  func set(_ viewControllers: [Presentable], animated: Bool, completion: PresentationHandler?) {
    let controllers = unwrapPresentables(viewControllers)

    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)

    rootController?.get().setViewControllers(controllers, animated: animated)

    CATransaction.commit()
  }

  func select(index: Int, completion: PresentationHandler?) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)

    rootController?.get().selectedIndex = index

    CATransaction.commit()
  }
}
