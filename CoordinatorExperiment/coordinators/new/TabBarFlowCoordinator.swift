// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum TabBarFlowRoute: Route {
  case first, second, third
}

class TabBarFlowCoordinator: TabBarCoordinator<TabBarFlowRoute>, CoordinatorOutput {
  func configure() -> TabBarFlowCoordinator.Output {
    return Output(logout: outputLogout.asObservable())
  }

  struct Output {
    let logout: Observable<Void>
  }

  private let outputLogout = PublishRelay<Void>()

  init() {
    super.init(controller: nil, initialRoute: .first)
    
    let first = NavFlowCoordinator(tag: 0, tabBarSystemItem: .favorites)
    let output = first.configure()
    output.didDeinit
      .do(onNext: { [weak self, weak first] _ in
        self?.removeChild(first)
        self?.router.rootController = nil
      })
      .drive(onNext: { [weak self] _ in
        self?.outputLogout.accept(())
    }).disposed(by: bag)
    startCoordinator(first)

    let second = NavFlowCoordinator(tag: 1, tabBarSystemItem: .history)
    second.define(coordinatorCustomPresentId: "second")
    _ = second.configure()
    startCoordinator(second)
    
    let third = NavExitTabFlowCoordinator(tag: 2, tabBarSystemItem: .more)
    third.define(coordinatorCustomPresentId: "third")
    let outputThird = third.configure()
    outputThird.completeFlow.drive(onNext: { [weak self] in
      self?.outputLogout.accept(())
      self?.removeAll()
    }).disposed(by: bag)
    startCoordinator(third)
    
    let vcs: [UIViewController] = [first.presentable(), second.presentable(), third.presentable()]
    router.set(vcs, animated: false, completion: nil)
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
    }
  }
  
  func removeAll() {
    for chaild in allChailds() {
      removeChild(chaild)
    }
  }

  deinit {
    print("Dead NewsCoordinator")
  }
}
