// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

extension Router where RootContainer: LirikaWindow {
  func container() -> LirikaWindow.Container {
    return rootController?.container ?? LirikaWindow.Container()
  }
  
  func setRoot(controller: Presentable) {
    container().rootViewController = controller.presentable()
  }
  
  func makeKeyAndVisible() {
    container().makeKeyAndVisible()
  }
}
