// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum NavModalFlowRoute: Route {
  case setAsRoot, push, pop
}

class NavModalFlowCoordinator: NavigationCoordinator<NavModalFlowRoute>, CoordinatorOutput {
  func configure() -> NavModalFlowCoordinator.Output {
    return Output(
      didDeinit: didDeinit.asDriver(onErrorJustReturn: ()),
      completeFlow: completeFlow.asDriver(onErrorJustReturn: ())
    )
  }

  struct Output {
    let didDeinit: Driver<Void>
    let completeFlow: Driver<Void>
  }

  // MARK: - Stored properties

  private var tag: Int = 0

  fileprivate let didDeinit = PublishRelay<Void>()
  fileprivate let completeFlow = PublishRelay<Void>()

  // MARK: - Init

  init(tag: Int, tabBarSystemItem: UITabBarItem.SystemItem) {
    super.init(container: nil, initialRoute: .setAsRoot)
    self.tag = tag
    rootContainer.get().tabBarItem = UITabBarItem(tabBarSystemItem: tabBarSystemItem, tag: tag)
  }

  init(rootViewController: LirikaNavigation?, initialRoute: NavModalFlowRoute) {
    super.init(container: rootViewController, initialRoute: initialRoute)
  }
  
  override func configureRootViewController() {
    rootContainer.get().navigationBar.isTranslucent = false
    rootContainer.get().navigationBar.prefersLargeTitles = true
  }

  // MARK: - Overrides

  override func prepare(route: NavModalFlowRoute, completion: PresentationHandler?) {
    switch route {
    case .setAsRoot:
      let controller = dummyController(title: "Modal navigation", actionButtonTitle: "Push", isFirst: true)
      router.set([controller], animated: false, completion: completion)

    case .push:
      let controller = dummyController(title: "Navigation next one", actionButtonTitle: "Push new one")
      router.push(controller)

    case .pop:
      router.pop()
    }
  }

  deinit {
    print("Dead NavFlowCoordinator")
  }
}

extension NavModalFlowCoordinator {
  fileprivate func dummyController(title: String, actionButtonTitle: String, isFirst: Bool = false) -> Presentable {
    let controller = ButtonsViewController()
    let input = ButtonsViewController.Input(
      controllerTitle: title,
      buttonTitle: actionButtonTitle,
      isFirstInStackController: isFirst
    )

    let output = controller.configure(input: input)

    let title: String = isFirst ? "Dismiss" : "Pop"
    controller.customView.buttonSecond.setTitle(title.uppercased(), for: .normal)

    output.tapFirstAction.drive(onNext: { [weak self] in
      self?.trigger(.push)
    }).disposed(by: bag)

    output.tabSecondAction.drive(onNext: { [weak self] _ in
      if isFirst {
        self?.completeFlow.accept(())
      } else {
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
