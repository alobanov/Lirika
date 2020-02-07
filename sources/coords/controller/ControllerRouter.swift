// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import UIKit

public extension Router where RootContainer: LirikaController {
  func container() -> LirikaController.Container {
    return rootController?.container ?? LirikaController.Container()
  }

  func addSubview(_ view: UIView) {
    container().view.addSubview(view)
  }

  func add(_ child: UIViewController, frame: CGRect? = nil) {
    container().addChild(child)

    if let frame = frame {
      child.view.frame = frame
    }

    container().view.addSubview(child.view)
    child.didMove(toParent: container())
  }

  func remove(_ child: UIViewController) {
    child.willMove(toParent: nil)
    child.view.removeFromSuperview()
    child.removeFromParent()
  }
}
