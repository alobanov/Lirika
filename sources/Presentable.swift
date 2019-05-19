// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

typealias PresentableID = String

protocol Presentable: AnyObject {
  func presentable() -> UIViewController
  func presentId() -> PresentableID
  static func presentId() -> PresentableID
}

extension Coordinator {
  public var viewController: UIViewController! {
    return (rootViewController.rootContainer() as! UIViewController)
  }
}

extension UIViewController: Presentable {
  func presentable() -> UIViewController {
    return self
  }

  func presentId() -> PresentableID {
    return String(describing: type(of: self))
  }

  static func presentId() -> PresentableID {
    return String(describing: self)
  }
}
