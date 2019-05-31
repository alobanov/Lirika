// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

public extension Router where RootContainer: LirikaPage {
  func container() -> LirikaPage.Container {
    return rootController?.container ?? LirikaPage.Container(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }

  func set(_ controllers: [UIViewController]?, direction: UIPageViewController.NavigationDirection, animated: Bool, completion: PresentationHandler?) {
    container().setViewControllers(controllers, direction: direction, animated: animated, completion: { _ in completion?() })
  }
}
