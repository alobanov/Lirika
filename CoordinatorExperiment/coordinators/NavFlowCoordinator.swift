// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum NavFlowRoute: Route {
  case pop
  case newDummy
  case setAsRoot
  case pushIntoExtistNav
}

class NavFlowCoordinator: NavigationCoordinator<NavFlowRoute>, CoordinatorInOut {
  func configure(input: Input = .init()) -> NavFlowCoordinator.Output {
    return Output(didDeinit: didDeinit.asDriver(onErrorJustReturn: ()))
  }
  
  struct Input {}

  struct Output {
    let didDeinit: Driver<Void>
  }

  // MARK: - Stored properties

  private var tag: Int = 0
  fileprivate let bag = DisposeBag()
  private let didDeinit = PublishRelay<Void>()

  // MARK: - Init

  convenience init(tag: Int, tabBarSystemItem: UITabBarItem.SystemItem) {
    self.init(initialRoute: .setAsRoot)
    self.tag = tag
    rootContainer.container.tabBarItem = UITabBarItem(tabBarSystemItem: tabBarSystemItem, tag: tag)
  }

  override func configureRootViewController() {
    rootContainer.container.navigationBar.isTranslucent = false
  }

  // MARK: - Overrides

  override func drive(route: NavFlowRoute, completion: PresentationHandler?) {
    switch route {
    case .setAsRoot:
      let controller = dummyController(title: "Navigation first", actionButtonTitle: "Push", isFirst: true)
      router.set([controller], animated: false, completion: completion)

    case .pop:
      router.pop()

    case .newDummy:
      let controller = dummyController(title: "Navigation next one", actionButtonTitle: "Push new one")
      router.push(controller)

    case .pushIntoExtistNav:
      let controller = dummyController(title: "Navigation first", actionButtonTitle: "Push", isFirst: true)
      router.push(controller)
    }
  }

  deinit {
    print("Dead NavFlowCoordinator")
  }
}

extension NavFlowCoordinator {
  func firstRootDummyController() {}

  func dummyController(title: String, actionButtonTitle: String, isFirst: Bool = false) -> Presentable {
    let controller = ButtonsViewController()
    let input = ButtonsViewController.Input(
      controllerTitle: title,
      buttonTitle: actionButtonTitle,
      isFirstInStackController: isFirst
    )

    let output = controller.configure(input: input)

    if isFirst {
      controller.customView.buttonSecond.isHidden = true
    }

    output.tapFirstAction.drive(onNext: { [weak self] in
      self?.trigger(.newDummy)
    }).disposed(by: bag)

    output.tabSecondAction.drive(onNext: { [weak self] in
      if !isFirst {
        self?.trigger(.pop)
      }
    }).disposed(by: bag)

    output.didDeinit.drive(onNext: { [weak self] in
      if isFirst {
        self?.didDeinit.accept(())
      }
    }).disposed(by: bag)

    return controller
  }
}
