// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

extension Router where RootContainer: LirikaWindow {
  func setRoot(controller: Presentable) {
    rootController?.get().rootViewController = controller.presentable()
  }
  
  func makeKeyAndVisible() {
    rootController?.get().makeKeyAndVisible()
  }
}
