// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift

enum AppRoute: Route {
  case options, tabbarFlow
}

class AppCoordinator: WindowCoordinator<AppRoute> {
  override func prepare(route: AppRoute, completion _: PresentationHandler?) {
    switch route {
    case .options:
      let coord = options()
      startCoordinator(coord)
      router.setRoot(controller: coord)
      router.makeKeyAndVisible()

    case .tabbarFlow:
      let coord = tabbar()
      startCoordinator(coord)
      router.setRoot(controller: coord)
    }
  }

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
    let optionCoord = OptionFlowCoordinator(container: nil, initialRoute: .options)
    let output = optionCoord.configure()

    output.tabbarFlow.drive(onNext: { [weak optionCoord, weak self] in
      self?.removeChild(optionCoord)
      self?.trigger(.tabbarFlow)
    }).disposed(by: bag)

    return optionCoord
  }
}
