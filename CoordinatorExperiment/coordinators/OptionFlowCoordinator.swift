// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum OptionFlowRoute: Route {
  case options, navigationFlow, tabbarFlow, modalFlow, dissmisModal, pageAsRootFlow, pageModalFlow, controllerModalFlow
}

class OptionFlowCoordinator: NavigationCoordinator<OptionFlowRoute>, CoordinatorInOut {
  func configure(input: Input = .init()) -> OptionFlowCoordinator.Output {
    return Output(tabbarFlow: tabbarFlow.asDriver(onErrorJustReturn: ()),
                  pageFlow: pageFlow.asDriver(onErrorJustReturn: ()))
  }

  struct Input {}

  struct Output {
    let tabbarFlow: Driver<Void>
    let pageFlow: Driver<Void>
  }

  private let tabbarFlow = PublishRelay<Void>()
  private let pageFlow = PublishRelay<Void>()
  fileprivate let bag = DisposeBag()

  override func drive(route: OptionFlowRoute, completion _: PresentationHandler?) {
    switch route {
    case .options:
      let contorller = options()
      contorller.captureCoordinator(self)
      router.set([contorller], animated: true)

    case .navigationFlow:
      navigationCoordinator().start()

    case .tabbarFlow:
      tabbarFlow.accept(())

    case .modalFlow:
      let coord = modalNavigationCoordinator()
      coord.start()
      router.presentModal(coord.presentable(), animated: true, completion: nil)

    case .dissmisModal:
      router.dismissModal(animated: true, completion: nil)

    case .pageAsRootFlow:
      pageFlow.accept(())

    case .pageModalFlow:
      let coord = pageCoordinator()
      startCoordinator(coord)
      router.presentModal(coord, animated: true, completion: nil)

    case .controllerModalFlow:
      let coord = controllerCoordinator()
      startCoordinator(coord)
      router.presentModal(coord, animated: true, completion: nil)
    }
  }

  override func configureRootViewController() {
    rootContainer.container.navigationBar.isTranslucent = false
    rootContainer.container.navigationBar.prefersLargeTitles = true
  }

  deinit {
    print("Dead OptionFlowCoordinator")
  }
}

extension OptionFlowCoordinator {
  fileprivate func controllerCoordinator() -> Coordinatorable {
    let controller = ControllerFlowCoordinator(container: LirikaController())
    let output = controller.configure()

    output.exit.drive(onNext: { [weak self, weak controller] _ in
      self?.removeChild(controller)
      self?.router.dismissModal(animated: true, completion: nil)
    }).disposed(by: bag)

    return controller
  }

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
      case .pageAsRoot:
        self?.trigger(.pageAsRootFlow)
      case .pageModal:
        self?.trigger(.pageModalFlow)
      case .controller:
        self?.trigger(.controllerModalFlow)
      }
    }).disposed(by: bag)

    return controller
  }

  fileprivate func navigationCoordinator() -> Coordinatorable {
    guard let curentRoot = router.rootController?.container else {
      fatalError()
    }

    return NavFlowCoordinator(
      container: LirikaNavigation(container: curentRoot),
      initialRoute: .pushIntoExtistNav
    )
  }

  fileprivate func modalNavigationCoordinator() -> Coordinatorable {
    let rootNav = LirikaNavigation(container: MyRootModalNavigationContainer())
    rootNav.container.navigationBar.isTranslucent = false
    rootNav.container.navigationBar.prefersLargeTitles = true

    let navCoord = NavModalFlowCoordinator(container: rootNav, initialRoute: .setAsRoot)
    return navCoord
  }

  fileprivate func pageCoordinator() -> Coordinatorable {
    let container = MyPageController()
    let root = LirikaPage(container: container)

    let pageCoord = PageFlowCoordinator(container: root, initialRoute: .prepareFirstPage)
    let output = pageCoord.configure()

    output.exit.asDriver(onErrorJustReturn: ()).drive(onNext: { [weak pageCoord, weak self] in
      self?.removeChild(pageCoord)
      self?.router.dismissModal(animated: true, completion: nil)
    }).disposed(by: bag)

    return pageCoord
  }
}
