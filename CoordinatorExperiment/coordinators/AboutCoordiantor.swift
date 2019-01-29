//
//  AboutCoordiantor.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright © 2019 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum AboutRoute: Route {  
  case about
  case details
  case back
}

class AboutCoordinator: NavigationCoordinator<AboutRoute>, CoordinatorOutput {
  func configure() -> AboutCoordinator.Output {
    return Output(logout: outputLogout.asObservable())
  }
  
  struct Output {
    let logout: Observable<Void>
  }
  
  private let outputLogout = PublishSubject<Void>()
  
  // MARK: - Init
  
  override init(rootViewController: UINavigationController?, initialRoute: AboutRoute) {
    super.init(rootViewController: rootViewController, initialRoute: initialRoute)
  }
  
  override func configureRootViewController() {
    rootViewController.navigationBar.isTranslucent = false
    rootViewController.navigationBar.prefersLargeTitles = true
    rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
  }
  
  // MARK: - Overrides
  
  override func prepare(route: AboutRoute, completion: PresentationHandler?) {
    switch route {
    case .about:
      router.set([about()], completion: completion)
    case .details:
      outputLogout.onNext(())
//      router.push(about())
    case .back:
      router.pop(toRoot: false, completion: completion)
    }
  }
  
  // MARK: - Overrides
  
  func about() -> Presentable {
    let (vc, module) = try! AboutConfigurator.configure(inputData: .init())
    module.moduleAction.subscribe(onNext: { [weak self] action in
      switch action {
      case .showSomething:
        self?.trigger(.details)
      }
    }).disposed(by: bag)
    
    return vc
  }
  
  func presentDetail() -> Presentable {
    let value = try! NewsConfigurator.configure(inputData: .init())    
    value.viewController.hidesBottomBarWhenPushed = true
    return value.viewController
  }
  
  deinit {
    print("Dead AboutCoordinator")
  }
}

