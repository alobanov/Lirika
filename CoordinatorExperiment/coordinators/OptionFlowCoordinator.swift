// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum OptionFlowRoute: Route {
  case options, navigationFlow, tabbarFlow, modalFlow, dissmisModal
}

class OptionFlowCoordinator: NavigationCoordinator<OptionFlowRoute>, CoordinatorOutput {
  func configure() -> OptionFlowCoordinator.Output {
    return Output(tabbarFlow: tabbarFlow.asDriver(onErrorJustReturn: ()))
  }

  struct Output {
    let tabbarFlow: Driver<Void>
  }

  private let tabbarFlow = PublishRelay<Void>()

  override func prepare(route: OptionFlowRoute, completion _: PresentationHandler?) {
    switch route {
    case .options:
      router.set([options()], animated: true)

    case .navigationFlow:
      let coord = navigationCoordinator()
      startCoordinator(coord)

    case .tabbarFlow:
      tabbarFlow.accept(())

    case .modalFlow:
      let coord = modalNavigationCoordinator()
      startCoordinator(coord.0)
      router.presentModal(coord.1, animated: true, completion: nil)

    case .dissmisModal:
      router.dismissModal(animated: true, completion: nil)
    }
  }

  override func configureRootViewController() {
    rootViewController.rootContainer().navigationBar.isTranslucent = false
    rootViewController.rootContainer().navigationBar.prefersLargeTitles = true
  }

  deinit {
    print("Dead NavFlowCoordinator")
  }
}

extension OptionFlowCoordinator {
  fileprivate func options() -> Presentable {
    let controller = OptionsViewController()
    let output = controller.configure(input: .init())

    output.tabbar.drive(onNext: { [weak self] action in
      switch action {
      case .modal:
        self?.trigger(.modalFlow)
      case .navigation:
        self?.trigger(.navigationFlow)
      case .tabbar:
        self?.trigger(.tabbarFlow)
      }
    }).disposed(by: bag)

    return controller
  }

  fileprivate func navigationCoordinator() -> Coordinatorable {
    guard let curentRoot = router.rootController?.rootContainer() else {
      fatalError()
    }

    let navCoord = NavFlowCoordinator(rootViewController: LirikaNavigation(container: curentRoot), initialRoute: .pushIntoExtistNav)
    let output = navCoord.configure()

    output.didDeinit.drive(onNext: { [weak navCoord, weak self] in
      self?.removeChild(navCoord)
    }).disposed(by: bag)

    return navCoord
  }

  fileprivate func modalNavigationCoordinator() -> (Coordinatorable, Presentable) {
    let rootNav = LirikaNavigation()
    rootNav.rootContainer().navigationBar.isTranslucent = false
    rootNav.rootContainer().navigationBar.prefersLargeTitles = true

    let navCoord = NavModalFlowCoordinator(rootViewController: rootNav, initialRoute: .setAsRoot)
    let output = navCoord.configure()

    output.didDeinit.drive(onNext: { [weak navCoord, weak self] in
      self?.removeChild(navCoord)
    }).disposed(by: bag)

    output.completeFlow.drive(onNext: { [weak navCoord, weak self] in
      rootNav.rootContainer().dismiss(animated: true, completion: nil)
      self?.removeChild(navCoord)
    }).disposed(by: bag)

    return (navCoord, rootNav.rootContainer())
  }
}
