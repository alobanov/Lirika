// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import UIKit

public typealias PresentableID = String

public protocol Presentable: AnyObject {
  func presentable() -> UIViewController
  func presentId() -> PresentableID
}

extension UIViewController: Presentable {
  public func presentable() -> UIViewController {
    return self
  }

  public func presentId() -> PresentableID {
    return "\(hashValue)"
  }
}
