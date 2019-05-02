// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift

enum AppRoute: Route {
  case options, navigationFlow, tabbarFlow, modalFlow, dissmisModal
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
  override func prepare(route: AppRoute, completion _: PresentationHandler?) {
    switch route {
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
      
    case .modalFlow:
      let coord = modalNavigationCoordinator()
      startCoordinator(coord.0)
      router.presentModal(coord.1, animated: true, completion: nil)
      
    case .dissmisModal:
      router.dismissModal(animated: true, completion: nil)
    }
  }

  override func configureRootViewController() {
    rootViewController.navigationBar.isTranslucent = false
    rootViewController.navigationBar.prefersLargeTitles = true
  }


  deinit {
    print("Dead AppCoordinator")
  }
}

extension AppCoordinator {
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
    guard let curentRoot = router.rootController else {
      fatalError()
    }
    
    let navCoord = NavFlowCoordinator(rootViewController: curentRoot, initialRoute: .pushIntoExtistNav)
    let output = navCoord.configure()
    
    output.didDeinit.drive(onNext: { [weak navCoord, weak self] in
      self?.removeChild(navCoord)
    }).disposed(by: bag)
    
    return navCoord
  }
  
  fileprivate func modalNavigationCoordinator() -> (Coordinatorable, Presentable) {
    let rootNav = UINavigationController()
    rootNav.navigationBar.isTranslucent = false
    rootNav.navigationBar.prefersLargeTitles = true
    
    let navCoord = NavModalFlowCoordinator(rootViewController: rootNav, initialRoute: .setAsRoot)
    let output = navCoord.configure()
    
    output.didDeinit.drive(onNext: { [weak navCoord, weak self] in
      self?.removeChild(navCoord)
    }).disposed(by: bag)
    
    output.completeFlow.drive(onNext: { [weak navCoord, weak self] in
      rootNav.dismiss(animated: true, completion: nil)
      self?.removeChild(navCoord)
    }).disposed(by: bag)
    
    return (navCoord, rootNav)
  }
}
