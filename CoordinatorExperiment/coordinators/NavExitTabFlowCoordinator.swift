// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum NavExitTabFlowRoute: Route {
  case setAsRoot
}

class NavExitTabFlowCoordinator: NavigationCoordinator<NavExitTabFlowRoute>, CoordinatorOutput {
  func configure() -> NavExitTabFlowCoordinator.Output {
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

    rootContainer.container.tabBarItem = UITabBarItem(tabBarSystemItem: tabBarSystemItem, tag: tag)
    rootContainer.container.navigationBar.isTranslucent = false
    rootContainer.container.navigationBar.prefersLargeTitles = true
  }

  init(rootViewController: LirikaNavigation?, initialRoute: NavExitTabFlowRoute) {
    super.init(container: rootViewController, initialRoute: initialRoute)
  }

  // MARK: - Overrides

  override func prepare(route: NavExitTabFlowRoute, completion: PresentationHandler?) {
    switch route {
    case .setAsRoot:
      let controller = dummyController(title: "Exit from tabbar", actionButtonTitle: "Exit", isFirst: true)
      router.set([controller], animated: false, completion: completion)
    }
  }

  deinit {
    print("Dead NavFlowCoordinator")
  }
}

extension NavExitTabFlowCoordinator {
  fileprivate func dummyController(title: String, actionButtonTitle: String, isFirst: Bool = false) -> Presentable {
    let controller = ButtonsViewController()
    let input = ButtonsViewController.Input(
      controllerTitle: title,
      buttonTitle: actionButtonTitle,
      isFirstInStackController: isFirst
    )

    let output = controller.configure(input: input)

    controller.customView.buttonSecond.isHidden = true

    output.tapFirstAction.drive(onNext: { [weak self] in
      self?.completeFlow.accept(())
    }).disposed(by: bag)

    output.tabSecondAction.drive(onNext: { _ in
      // nothing
    }).disposed(by: bag)

    output.didDeinit.drive(onNext: { [weak self] in
      self?.didDeinit.accept(())
    }).disposed(by: bag)

    return controller
  }
}
