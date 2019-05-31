// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import UIKit

public protocol DeepLink {}

public extension Coordinator {
  typealias RootContainerType = RouterType.RootContainer
}

open class Coordinator<RouteType: Route, RouterType: RouterProtocol>: Coordinatorable {
  // MARK: - Properties

  // All child presentables modules (contorollers, coordinators)
  public var childs: [Presentable] = []

  // Define custom coordinator/module identifier if you use same module more then one times
  public var customCoordinatorNameIdentifier: String?

  // Route from which the coordinator starts
  public var initialRoute: RouteType?

  public var rootContainer: RootContainerType

  public let router: Router<RootContainerType>

  // MARK: - Init

  public init(container: RootContainerType, initialRoute: RouteType? = nil) {
    self.initialRoute = initialRoute
    self.router = Router<RootContainerType>()
    self.rootContainer = container
    router.define(root: rootContainer)
    configureRootViewController()
  }

  // MARK: - Public

  open func start() {
    guard let route = initialRoute else {
      return
    }

    trigger(route)
  }

  open func configureRootViewController() {}

  public func startCoordinator(_ coordinator: Coordinatorable) {
    addChild(coordinator)
    coordinator.start()
  }

  public func addChild(_ child: Presentable) {
    for element in childs where element.presentId() == child.presentId() {
      return
    }

    childs.append(child)
  }

  public func removeChild(_ child: Presentable?) {
    guard childs.isEmpty == false, let child = child else {
      return
    }

    for (index, element) in childs.enumerated() where element.presentId() == child.presentId() {
      childs.remove(at: index)
      break
    }
  }

  public func removeAllChilds() {
    for chaild in allChailds() {
      removeChild(chaild)
    }
  }

  public func define(coordinatorCustomPresentId id: String) {
    customCoordinatorNameIdentifier = id
  }

  public func child(presentId: PresentableID) -> Presentable? {
    return childs.first(where: { item -> Bool in
      item.presentId() == presentId
    })
  }

  public func allChailds() -> [Presentable] {
    return childs
  }

  open func drive(route: RouteType, completion: PresentationHandler?) {
    fatalError("Please override the \(#function) method.")
  }

  public func trigger(_ route: RouteType, comletion: PresentationHandler? = nil) {
    drive(route: route, completion: comletion)
  }

  open func deepLink(link: DeepLink) {}

  // MARK: - Private

  public func lastChild() -> Coordinatorable? {
    if let coord = childs.last as? Coordinatorable {
      print("Coordinator next is: \(coord.presentId())")
      return coord
    }
    return nil
  }
}

// MARK: - Coordinator presentable

extension Coordinator: Presentable {
  public func presentable() -> UIViewController {
    return router.presentable()
  }

  public func presentId() -> PresentableID {
    if let id = customCoordinatorNameIdentifier {
      return id
    }
    return presentable().presentId()
  }
}
