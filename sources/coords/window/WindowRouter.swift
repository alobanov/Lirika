// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import UIKit

public extension Router where RootContainer: LirikaWindow {
  func container() -> LirikaWindow.Container {
    return rootController?.container ?? LirikaWindow.Container()
  }

  func setRoot(controller: Presentable) {
    guard container().rootViewController != nil else {
      container().rootViewController = controller.presentable()
      return
    }

    guard let snapShot: UIView = container().snapshotView(afterScreenUpdates: true) else {
      container().rootViewController = controller.presentable()
      return
    }

    container().rootViewController = controller.presentable()
    controller.presentable().view.addSubview(snapShot)

    UIView.animate(
      withDuration: 0.3, delay: 0,
      options: [.curveEaseInOut, .transitionCrossDissolve, .beginFromCurrentState],
      animations: {
        snapShot.layer.opacity = 0
        snapShot.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.1)
      }, completion: { _ in
        snapShot.removeFromSuperview()
      }
    )
  }

  func makeKeyAndVisible() {
    container().makeKeyAndVisible()
  }
}
