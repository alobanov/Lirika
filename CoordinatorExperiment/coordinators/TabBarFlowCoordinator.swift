// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum TabBarFlowRoute: Route {
  case first, second, third, exit
}

class TabBarFlowCoordinator: TabBarCoordinator<TabBarFlowRoute>, CoordinatorOutput {
  func configure() -> TabBarFlowCoordinator.Output {
    return Output(logout: outputLogout.asObservable())
  }

  struct Output {
    let logout: Observable<Void>
  }

  fileprivate let outputLogout = PublishRelay<Void>()

  init() {
    super.init(controller: nil, initialRoute: .third)
    router.set(buildTabs(), animated: false, completion: nil)
  }

  func buildTabs() -> [UIViewController] {
    let coords = [
      firstTabCoordinator(),
      secondTabCoordinator(),
      thirdTabCoordinator(),
    ]

    coords.forEach { startCoordinator($0) }
    return coords.map { $0.presentable() }
  }

  // MARK: - Overrides

  override func prepare(route: TabBarFlowRoute, completion: PresentationHandler?) {
    switch route {
    case .first:
      router.select(index: 0, completion: completion)
    case .second:
      router.select(index: 1, completion: completion)
    case .third:
      router.select(index: 2, completion: completion)
    case .exit:
      outputLogout.accept(())
      removeAllChilds()
    }
  }

  deinit {
    print("Dead NewsCoordinator")
  }
}

extension TabBarFlowCoordinator {
  fileprivate func firstTabCoordinator() -> Coordinatorable {
    let first = NavFlowCoordinator(tag: 0, tabBarSystemItem: .favorites)
    _ = first.configure()
    return first
  }

  fileprivate func secondTabCoordinator() -> Coordinatorable {
    let second = NavFlowCoordinator(tag: 1, tabBarSystemItem: .history)
    second.define(coordinatorCustomPresentId: "second")
    _ = second.configure()
    return second
  }

  fileprivate func thirdTabCoordinator() -> Coordinatorable {
    let third = NavExitTabFlowCoordinator(tag: 2, tabBarSystemItem: .more)
    third.define(coordinatorCustomPresentId: "third")
    let outputThird = third.configure()
    outputThird.completeFlow.drive(onNext: { [weak self] in
      self?.trigger(.exit)
    }).disposed(by: bag)
    return third
  }
}
