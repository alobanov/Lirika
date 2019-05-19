// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

extension Router where RootContainer: LirikaWindow {
  func setRootCoordinator(controller: Presentable) {
    rootController?.get().rootViewController = controller.presentable()
    rootController?.get().makeKeyAndVisible()
  }
}
