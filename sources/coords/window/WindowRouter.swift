// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

extension Router where RootViewController: LirikaWindow {
  func setRootCoordinator(controller: Presentable) {
    rootController?.rootContainer().rootViewController = controller.presentable()
    rootController?.rootContainer().makeKeyAndVisible()
  }
}
