// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

typealias PresentableID = String

protocol Presentable: AnyObject {
  func presentable() -> UIViewController
  func presentId() -> PresentableID
  static func presentId() -> PresentableID
  func setRoot(for window: UIWindow)
}

extension Presentable {
  func setRoot(for window: UIWindow) {
    window.rootViewController = presentable()
    window.makeKeyAndVisible()
  }
}

extension Coordinator {
  public var viewController: UIViewController! {
    return rootViewController
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
