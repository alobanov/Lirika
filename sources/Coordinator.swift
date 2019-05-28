// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import UIKit

protocol DeepLink {}

extension Coordinator {
  public typealias RootContainerType = RouterType.RootContainer
}

class Coordinator<RouteType: Route, RouterType: RouterProtocol>: Coordinatorable {
  // MARK: - Properties

  // All child presentables modules (contorollers, coordinators)
  private var childs: [Presentable] = []

  // Define custom coordinator/module identifier if you use same module more then one times
  private var customCoordinatorNameIdentifier: String?

  // Route from which the coordinator starts
  var initialRoute: RouteType?

  var rootContainer: RootContainerType

  let router: Router<RootContainerType>

  // MARK: - Init

  init(container: RootContainerType, initialRoute: RouteType? = nil) {
    self.initialRoute = initialRoute
    self.router = Router<RootContainerType>()
    self.rootContainer = container
    router.define(root: rootContainer)
    configureRootViewController()
  }

  // MARK: - Public

  func start() {
    guard let route = initialRoute else {
      return
    }

    trigger(route)
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
    guard childs.isEmpty == false, let child = child else {
      return
    }

    for (index, element) in childs.enumerated() where element.presentId() == child.presentId() {
      childs.remove(at: index)
      break
    }
  }

  func removeAllChilds() {
    for chaild in allChailds() {
      removeChild(chaild)
    }
  }

  func define(coordinatorCustomPresentId id: String) {
    customCoordinatorNameIdentifier = id
  }

  func child(presentId: PresentableID) -> Presentable? {
    let items = childs.filter { item -> Bool in
      item.presentId() == presentId
    }
    return items.first
  }

  func allChailds() -> [Presentable] {
    return childs
  }

  func drive(route: RouteType, completion: PresentationHandler?) {
    fatalError("Please override the \(#function) method.")
  }

  func trigger(_ route: RouteType, comletion: PresentationHandler? = nil) {
    drive(route: route, completion: comletion)
  }

  func deepLink(link: DeepLink) {}

  // MARK: - Private

  private func lastChild() -> Coordinatorable? {
    if let coord = childs.last as? Coordinatorable {
      print("Coordinator next is: \(coord.presentId())")
      return coord
    }
    return nil
  }
}

// MARK: - Coordinator presentable

extension Coordinator: Presentable {
  func presentable() -> UIViewController {
    return router.presentable()
  }

  func presentId() -> PresentableID {
    if let id = customCoordinatorNameIdentifier {
      return id
    }
    return presentable().presentId()
  }
}
