//
//  HomeCoordinator.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright © 2019 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

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
  
  init(rootViewController: UINavigationController, initialRoute: HomeRoute) {
    super.init(rootViewController: rootViewController, initialRoute: initialRoute)
  }
  
  // MARK: - Overrides
  
  override func prepare(route: HomeRoute, completion: PresentationHandler?) {
    switch route {
    case .home:
      router.set([home()], completion: completion)
      // setModules([], hideBar: false, animated: false)
    case .news:
      let coord = NewsCoordinator()
      startCoordinator(coord)
      router.set([coord.presentable()], completion: completion, barHidden: true)
      //setModules([coord.presentable()], hideBar: true, animated: false)
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
