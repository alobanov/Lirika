// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum NewsRoute: Route {
  case seletAbout, selectNews
}

class NewsCoordinator: TabBarCoordinator<NewsRoute>, CoordinatorOutput {
  func configure() -> NewsCoordinator.Output {
    return Output(logout: outputLogout.asObservable())
  }

  struct Output {
    let logout: Observable<Void>
  }

  private let outputLogout = PublishRelay<Void>()

  init() {
    super.init(controller: nil, initialRoute: .selectNews)
//    super.init(rootViewController: nil, initialRoute: .selectNews)
//    super.init(rootViewController: nil, initialRoute: .selectNews)

    let home = AboutCoordinator(controller: nil, initialRoute: .about)
    let output = home.configure()
    output.logout.do(onNext: { [weak self, weak home] _ in
      self?.removeChild(home)
      self?.router.rootController = nil
    }).bind(to: outputLogout).disposed(by: bag)
    startCoordinator(home)

    let value = try! NewsListConfigurator.configure(inputData: .init())
    
    let value1 = try! AuthConfigurator.configure(inputData: .init())
    
    router.set([home.presentable(), value.viewController, value1.viewController], animated: false, completion: nil)
  }

  override func start() {
    trigger(.seletAbout)
  }

  // MARK: - Overrides

  override func prepare(route: NewsRoute, completion: PresentationHandler?) {
    switch route {
    case .seletAbout:
      router.select(index: 0, completion: completion)
    case .selectNews:
      router.select(index: 1, completion: completion)
    }
  }

  deinit {
    print("Dead NewsCoordinator")
  }
}
