// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum HomeRoute: Route {
  case home
  case news
}

class HomeCoordinator: NavigationCoordinator<HomeRoute>, CoordinatorOutput {
  func configure() -> HomeCoordinator.Output {
    return Output(didDeinit: didDeinit.asObservable())
  }

  struct Output {
    let didDeinit: Observable<Void>
  }

  // MARK: - Stored properties

  private let didDeinit = PublishSubject<Void>()

  // MARK: - Init

  //  init(rootViewController: UINavigationController, initialRoute: HomeRoute) {
//    super.init(rootViewController: rootViewController, initialRoute: initialRoute)
  //  }

  // MARK: - Overrides

  override func prepare(route: HomeRoute, completion: PresentationHandler?) {
    switch route {
    case .home:
      router.set([home()], animated: false, completion: completion)
    case .news:
      let coord = NewsCoordinator()
      startCoordinator(coord)
      router.set([coord.presentable()], animated: false, completion: completion, barHidden: true)
    }
  }

  deinit {
    print("Dead HomeCoordinator")
  }
}

extension HomeCoordinator {
  func home() -> Presentable {
    let value = try! HomeConfigurator.configure(inputData: HomeViewModel.ModuleInputData())
    value.moduleOutput.moduleAction.subscribe(onNext: { [weak self] action in
      switch action {
      case .deInit:
        self?.didDeinit.onNext(())
      case .back:
        self?.trigger(.news)
      }
    }).disposed(by: bag)

    return value.viewController
  }
}
