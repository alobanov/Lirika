//
//  NavFlowCoordinator.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 01/05/2019.
//  Copyright © 2019 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum NavFlowRoute: Route {
  case pop
  case newDummy
  case setAsRoot
  case pushIntoExtistNav
}

class NavFlowCoordinator: NavigationCoordinator<NavFlowRoute>, CoordinatorOutput {
  func configure() -> NavFlowCoordinator.Output {
    return Output(didDeinit: didDeinit.asDriver(onErrorJustReturn: ()))
  }
  
  struct Output {
    let didDeinit: Driver<Void>
  }
  
  // MARK: - Stored properties
  private var tag: Int = 0
  
  private let didDeinit = PublishRelay<Void>()
  
  // MARK: - Init
  
  init(tag: Int, tabBarSystemItem: UITabBarItem.SystemItem) {
    super.init(controller: nil, initialRoute: .setAsRoot)
    self.tag = tag
    rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: tabBarSystemItem, tag: tag)
    
    rootViewController.navigationBar.isTranslucent = false
    rootViewController.navigationBar.prefersLargeTitles = true
  }

  init(rootViewController: UINavigationController?, initialRoute: NavFlowRoute) {
    super.init(controller: rootViewController, initialRoute: initialRoute)
  }
  
  // MARK: - Overrides
  
  override func prepare(route: NavFlowRoute, completion: PresentationHandler?) {
    switch route {
    case .setAsRoot:
      let controller = dummyController(title: "Navigation first", actionButtonTitle: "Push", isFirst: true)
      router.set([controller], animated: false, completion: completion)
      
    case .pop:
      router.pop()
      
    case .newDummy:
      let controller = dummyController(title: "Navigation next one", actionButtonTitle: "Push new one")
      router.push(controller)
      
    case .pushIntoExtistNav:
      let controller = dummyController(title: "Navigation first", actionButtonTitle: "Push", isFirst: true)
      router.push(controller)
    }
  }
  
  deinit {
    print("Dead NavFlowCoordinator")
  }
}

extension NavFlowCoordinator {
  func firstRootDummyController() {
    
  }
  
  func dummyController(title: String, actionButtonTitle: String, isFirst: Bool = false) -> Presentable {
    let controller = SingleButtonViewController()
    let input = SingleButtonViewController.Input(
      controllerTitle: title,
      buttonTitle: actionButtonTitle,
      isFirstInStackController: isFirst)
    
    let output = controller.configure(input: input)
    
    if isFirst {
      controller.customView.buttonSecond.isHidden = true
    }
    
    output.tapFirstAction.drive(onNext: { [weak self] in
      self?.trigger(.newDummy)
    }).disposed(by: bag)
    
    output.tabSecondAction.drive(onNext: { [weak self] in
      if !isFirst {
        self?.trigger(.pop)
      }
    }).disposed(by: bag)
    
    output.didDeinit.drive(onNext: { [weak self] in
      if isFirst {
        self?.didDeinit.accept(())
      }
    }).disposed(by: bag)
    
    return controller
  }
}

