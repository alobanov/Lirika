// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import UIKit

public extension Router where RootContainer: LirikaTabBar {
  func container() -> LirikaTabBar.Container {
    return rootController?.container ?? LirikaTabBar.Container()
  }

  func set(_ viewControllers: [Presentable], animated: Bool, completion: PresentationHandler?) {
    let controllers = unwrapPresentables(viewControllers)

    wrapAnimation(animation: { [weak self] in
      self?.container().setViewControllers(controllers, animated: animated)
    }, completion: completion)
  }

  func select(index: Int, completion: PresentationHandler?) {
    wrapAnimation(animation: { [weak self] in
      self?.container().selectedIndex = index
    }, completion: completion)
  }
}
