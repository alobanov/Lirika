import UIKit

public protocol CoordinatroStoreContainerProtocol {
  func addCoordinator(_ coordinator: Coordinatorable)
  func removeCoordinator(_ coordinator: Coordinatorable?)
  func resetCoordinators()
}

extension UIResponder: CoordinatroStoreContainerProtocol {
  public func addCoordinator(_ coordinator: Coordinatorable) {
    var list = storedCoordinators
    list.append(coordinator)
    associatedCoordinators = list
  }
  
  public func removeCoordinator(_ coordinator: Coordinatorable?) {
    guard let coordinator = coordinator else {
      return
    }
    
    var list = storedCoordinators
    list.removeAll(where: { $0.presentId() == coordinator.presentId() })
    associatedCoordinators = list
  }
  
  public func resetCoordinators() {
    switch self {
    case let value as UINavigationController:
      value.viewControllers.forEach({ $0.resetCoordinators() })
    case let value as UITabBarController:
      value.viewControllers?.forEach({ $0.resetCoordinators() })
    case let value as UIWindow:
      value.rootViewController?.resetCoordinators()
    default:
      break
    }
    
    associatedCoordinators = nil
  }
}

private var associatedObjectHandle: UInt8 = 0

extension UIResponder {
  var storedCoordinators: [Coordinatorable] {
    if let list = associatedCoordinators {
      return list
    }
    
    let list: [Coordinatorable] = []
    associatedCoordinators = list
    return list
  }
  
  var associatedCoordinators: [Coordinatorable]? {
    set {
      objc_setAssociatedObject(self, &associatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    get {
      return objc_getAssociatedObject(self, &associatedObjectHandle) as? [Coordinatorable] ?? []
    }
  }
}
