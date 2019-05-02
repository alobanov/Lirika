// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift

enum AppRoute: Route {
  case authorization, home, pop, options, navigationFlow, tabbarFlow
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
  override func prepare(route: AppRoute, completion _: PresentationHandler?) {
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
    case .options:
      router.set([options()], animated: true)
    case .navigationFlow:
      let coord = navigationCoordinator()
      
      startCoordinator(coord)
    case .tabbarFlow:
      let coord = TabBarFlowCoordinator()
      let output = coord.configure()
      output.logout.subscribe(onNext: { [weak self, weak coord] in
        self?.removeChild(coord)
        self?.trigger(.options)
      }).disposed(by: bag)
      startCoordinator(coord)
      router.set([coord], animated: false, barHidden: true)
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
  func options() -> Presentable {
    let controller = StartViewController()
    let output = controller.configure(input: .init())

    output.tabbar.drive(onNext: { [weak self] action in
      switch action {
      case .modal:
        break
      case .navigation:
        self?.trigger(.navigationFlow)
      case .tabbar:
        self?.trigger(.tabbarFlow)
      }
    }).disposed(by: bag)

    return controller
  }
  
  func navigationCoordinator() -> Coordinatorable {
    guard let cuurentRoot = router.rootController else {
      fatalError()
    }
    
    let navCoord = NavFlowCoordinator(rootViewController: cuurentRoot, initialRoute: .pushIntoExtistNav)
    let output = navCoord.configure()
    
    output.didDeinit.drive(onNext: { [weak navCoord, weak self] in
      self?.removeChild(navCoord)
    }).disposed(by: bag)
    
    return navCoord
  }

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
