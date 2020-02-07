// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift

class MyWindow: LirikaWindow.Container {
  // это собственный класс UIWindow в который можно добавить свою логику
  // ниже смотри как его использовать при инициализации координатора
}

enum AppRoute: Route {
  case options, tabbarFlow, pageFlow
}

class AppCoordinator: WindowCoordinator<AppRoute> {
  fileprivate let bag = DisposeBag()

  override func drive(route: AppRoute, completion: PresentationHandler?) {
    switch route {
    case .options:
      let coord = options()
      startCoordinator(coord)
      router.setRoot(controller: coord)

    case .tabbarFlow:
      let coord = tabbar()
      startCoordinator(coord)
      router.setRoot(controller: coord)

    case .pageFlow:
      let coord = page()
      startCoordinator(coord)
      router.setRoot(controller: coord)
    }
  }

  override func start() {
    trigger(.options)
    router.makeKeyAndVisible()
  }

  override func configureRootViewController() {}

//  override func deepLink(link: DeepLink) {
//    switch link {
//    case let item as? ConcreteDeepLink:
//      // выполняем переход
//    default:
//      break
//    }
//  }

  deinit {
    print("Dead AppCoordinator")
  }
}

extension AppCoordinator {
  fileprivate func tabbar() -> Coordinatorable {
    let coord = TabBarFlowCoordinator()
    let output = coord.configure()

    output.logout.subscribe(onNext: { [weak self, weak coord] in
      self?.removeChild(coord)
      self?.trigger(.options)
    }).disposed(by: bag)

    return coord
  }

  fileprivate func options() -> Coordinatorable {
    let optionCoord = OptionFlowCoordinator(initialRoute: .options)
    let output = optionCoord.configure()

    output.tabbarFlow.drive(onNext: { [weak optionCoord, weak self] in
      self?.removeChild(optionCoord)
      self?.trigger(.tabbarFlow)
    }).disposed(by: bag)

    output.pageFlow.drive(onNext: { [weak optionCoord, weak self] in
      self?.removeChild(optionCoord)
      self?.trigger(.pageFlow)
    }).disposed(by: bag)

    return optionCoord
  }

  fileprivate func page() -> Coordinatorable {
    let container = MyPageController()
    let root = LirikaPage(container: container)

    let pageCoord = PageFlowCoordinator(container: root, initialRoute: .prepareFirstPage)
    let output = pageCoord.configure()

    output.exit.asDriver(onErrorJustReturn: ()).drive(onNext: { [weak pageCoord, weak self] in
      self?.removeChild(pageCoord)
      self?.trigger(.options)
    }).disposed(by: bag)

    return pageCoord
  }
}
