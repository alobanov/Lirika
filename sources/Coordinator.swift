// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import Foundation
import UIKit

public protocol DeepLink {
  var isPostponed: Bool { get }
  func setPostponed(_ state: Bool)
}

public extension Coordinator {
  typealias RootContainerType = RouterType.RootContainer
}

open class Coordinator<RouteType: Route, RouterType: RouterProtocol>: Coordinatorable, Hashable {
  public static func == (lhs: Coordinator<RouteType, RouterType>, rhs: Coordinator<RouteType, RouterType>) -> Bool {
    return rhs.id == lhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  // MARK: - Properties

  // All child presentables modules (contorollers, coordinators)
  private var childs: [Presentable] = []

  // Define custom coordinator/module identifier if you use same module more then one times
  private var customCoordinatorNameIdentifier: String?
  private let identifier = UUID().uuidString

  public var id: String {
    return customCoordinatorNameIdentifier ?? identifier
  }

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
    guard let customIdentifier = customCoordinatorNameIdentifier else { return identifier }
    return customIdentifier
  }
}
