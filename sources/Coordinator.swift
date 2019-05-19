// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
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

  // Root controller depends on RootControllerType
  let rootContainerBox = ReferenceBox<RootContainerType>()

  // Route from which the coordinator starts
  var initialRoute: RouteType?

  var rootContainer: RootContainerType {
    // swiftlint:disable:next force_unwrapping
    return rootContainerBox.get()!
  }

  let bag = DisposeBag()

  let router: Router<RootContainerType>

  // MARK: - Init

  init(controller: RootContainerType?, initialRoute: RouteType? = nil) {
    self.initialRoute = initialRoute
    self.router = Router<RootContainerType>()

    if let controller = controller {
      rootContainerBox.set(controller)
    } else {
      rootContainerBox.set(self.generateRootContainer())
    }

    self.router.define(root: rootContainer)
    self.configureRootViewController()
  }

  // MARK: - Public

  func generateRootContainer() -> RootContainerType {
    return LirikaNavigation() as! RouterType.RootContainer
  }

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
    guard let id = customCoordinatorNameIdentifier else {
      return String(describing: type(of: self))
    }

    return id
  }

  static func presentId() -> PresentableID {
    return String(describing: self)
  }
}
