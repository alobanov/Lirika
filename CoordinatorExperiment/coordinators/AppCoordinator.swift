//
//  AppCoordinator.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright © 2019 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum AppRoute: Route {
  case authorization, home, pop
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
  override func prepare(route: AppRoute, completion: PresentationHandler?) {
    switch route {
    case .home:
      let coord = news()
      startCoordinator(coord)
      router.set([coord], animated: false, barHidden: true)
    case .authorization:
      let coord = auth()
      startCoordinator(coord)
    case .pop:
      router.pop(toRoot: false)
    }
  }
  
  override func configureRootViewController() {
    rootViewController.navigationBar.isTranslucent = false
    rootViewController.navigationBar.prefersLargeTitles = true
  }
  
  override func deepLink(link: DeepLink) {
    switch link {
    case let event as SignupDeepLink:
      coordinator(by: AuthCoordinator.self)?.deepLink(link: event)
    default:
      break
    }
  }
  
  deinit {
    print("Dead AppCoordinator")
  }
}

extension AppCoordinator {
  func auth() -> Coordinatorable {
    let auth = AuthCoordinator(controller: rootViewController, initialRoute: .auth)
    
    let output = auth.configure()
    output.successLogin.subscribe(onNext: { [weak self, weak auth] _ in
      self?.removeChild(auth)
      self?.trigger(.home)
    }).disposed(by: bag)
    
    return auth
  }
  
  func home() -> Coordinatorable {
    let home = HomeCoordinator(controller: rootViewController, initialRoute: .home)
    let output = home.configure()
    
    output.didDeinit.subscribe(onNext: { [weak self, weak home] _ in
      self?.removeChild(home)
    }).disposed(by: bag)
    
    return home
  }
  
  func news() -> Coordinatorable {
    let news = NewsCoordinator()
    let output = news.configure()
    
    output.logout.subscribe(onNext: { [weak self, weak news] _ in
      self?.removeChild(news)
      self?.trigger(.authorization)
    }).disposed(by: bag)
    
    return news
  }
}
