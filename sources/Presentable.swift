// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import UIKit

public typealias PresentableID = String

public protocol Presentable: AnyObject {
  func presentable() -> UIViewController
  func presentId() -> PresentableID
  func captureCoordinator(_ coordinator: Coordinatorable)
}

extension UIViewController: Presentable {
  public func presentable() -> UIViewController {
    return self
  }

  public func presentId() -> PresentableID {
    return String(describing: self)
  }
  
  public func captureCoordinator(_ coordinator: Coordinatorable) {
    addCoordinator(coordinator)
  }
}
