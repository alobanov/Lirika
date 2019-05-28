// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum TabBarFlowRoute: Route {
  case first, second, third, fourth, exit
}

class TabBarFlowCoordinator: TabBarCoordinator<TabBarFlowRoute>, CoordinatorOutput {
  func configure() -> TabBarFlowCoordinator.Output {
    return Output(logout: outputLogout.asObservable())
  }

  struct Output {
    let logout: Observable<Void>
  }

  fileprivate let outputLogout = PublishRelay<Void>()
  fileprivate let bag = DisposeBag()

  convenience init() {
    self.init(initialRoute: .third)
  }

  override func configureRootViewController() {
    router.set(buildTabs(), animated: false, completion: nil)
  }

  func buildTabs() -> [UIViewController] {
    let coords = [
      firstTabCoordinator(),
      secondTabCoordinator(),
      thirdTabCoordinator(),
      page(),
    ]

    coords.forEach { startCoordinator($0) }
    return coords.map { $0.presentable() }
  }

  // MARK: - Overrides

  override func drive(route: TabBarFlowRoute, completion: PresentationHandler?) {
    switch route {
    case .first:
      router.select(index: 0, completion: completion)
    case .second:
      router.select(index: 1, completion: completion)
    case .third:
      router.select(index: 2, completion: completion)
    case .fourth:
      router.select(index: 3, completion: completion)
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

  fileprivate func page() -> Coordinatorable {
    let pageCoord = PageFlowCoordinator(container: LirikaPage(), initialRoute: .prepareForTabBar(tag: 3))
    let output = pageCoord.configure()

    output.exit.asDriver(onErrorJustReturn: ()).drive(onNext: { [weak self] in
      self?.trigger(.third)
    }).disposed(by: bag)

    return pageCoord
  }
}
