// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol DeepLink {
}

extension Coordinator {
  public typealias RootControllerType = RouterType.RootViewController
}

class Coordinator<RouteType: Route, RouterType: RouterProtocol>: Coordinatorable {  
  private var childs: [Presentable] = []
  
  let rootViewControllerBox = ReferenceBox<RootControllerType>()
  var window: UIWindow?
  var initialRoute: RouteType
  
  var rootViewController: RootControllerType {
    // swiftlint:disable:next force_unwrapping
    return rootViewControllerBox.get()!
  }

  let bag = DisposeBag()
  let router: Router<RootControllerType>
    
  func configureWindow(window: UIWindow) {
    self.window = window
    setRoot(for: window)
  }
  
  convenience init(window: UIWindow, initialRoute: RouteType) {
    self.init(controller: nil, initialRoute: initialRoute)
    self.configureWindow(window: window)
  }
  
  init(controller: RootControllerType?, initialRoute: RouteType) {
    self.initialRoute = initialRoute
    self.router = Router<RootControllerType>()
    
    if let controller = controller {
      rootViewControllerBox.set(controller)
    } else {
      rootViewControllerBox.set(self.generateRootViewController())
    }
    
    self.router.define(root: rootViewController)
    self.configureRootViewController()
  }
  
  func generateRootViewController() -> RootControllerType {
    return RootControllerType()
  }

  func start() {
    trigger(initialRoute)
  }
  
  func configureRootViewController() {}

  func startCoordinator(_ coordinator: Coordinatorable) {
    addChild(coordinator)
    coordinator.start()
  }

  func addChild(_ child: Presentable) {
    for element in childs where element.presentId() == child.presentId() {
      return
    }

    childs.append(child)
  }

  func removeChild(_ child: Presentable?) {
    guard childs.isEmpty == false,
      let child = child
    else {
      return
    }

    for (index, element) in childs.enumerated() where element.presentId() == child.presentId() {
      childs.remove(at: index)
      break
    }
  }
  
  private func lastChild() -> Coordinatorable? {
    if let coord = childs.last as? Coordinatorable {
      print("Coordinator next is: \(coord.presentId())")
      return coord
    }
    
    return nil
  }

  func child(presentId: PresentableID) -> Presentable? {
    let items = childs.filter { item -> Bool in
      return item.presentId() == presentId
    }
    return items.first
  }
  
  func coordinator<T: Coordinatorable>(by type: T.Type) -> Coordinatorable? {
    return child(presentId: type.presentId()) as? Coordinatorable
  }

  func prepare(route: RouteType, completion: PresentationHandler?) {
    fatalError("Please override the \(#function) method.")
  }

  func trigger(_ route: RouteType, comletion: PresentationHandler? = nil) {
    prepare(route: route, completion: comletion)
  }
  
  func deepLink(link: DeepLink) {}
}

extension Coordinator: Presentable {
  func presentable() -> UIViewController {
    return router.presentable()
  }

  func presentId() -> PresentableID {
    return String(describing: type(of: self))
  }

  static func presentId() -> PresentableID {
    return String(describing: self)
  }
}
