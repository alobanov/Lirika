// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift

class SignupDeepLink: DeepLink {}

enum AuthRoute: Route {
  case auth
  case signin
  case signup
  case successLogin
  case popToRoot
}

class AuthCoordinator: NavigationCoordinator<AuthRoute>, CoordinatorOutput {
  struct Output {
    let successLogin: Observable<Void>
  }

  func configure() -> AuthCoordinator.Output {
    return Output(successLogin: outputSuccessLogin.asObservable())
  }

  private let outputSuccessLogin = PublishSubject<Void>()

  //  override init(rootViewController: UINavigationController?, initialRoute: AuthRoute) {
//    super.init(rootViewController: rootViewController, initialRoute: initialRoute)
  //  }

  override func prepare(route: AuthRoute, completion _: PresentationHandler?) {
    switch route {
    case .auth:
      router.setImmediately([auth()])
    case .signin:
      router.push(signin())
    case .signup:
      router.push(signup())
    case .successLogin:
      outputSuccessLogin.onNext(())
    case .popToRoot:
      router.pop(toRoot: true)
    }
  }

  override func deepLink(link: DeepLink) {
    switch link {
    case _ as SignupDeepLink:
      trigger(.signin)
      trigger(.signup)
    default:
      break
    }
  }

  deinit {
    print("Dead AuthCoordinator")
  }
}

extension AuthCoordinator {
  func auth() -> Presentable {
    let module = try! AuthConfigurator.configure(inputData: .init())
    module.moduleOutput.moduleAction.subscribe(onNext: { [weak self] action in
      switch action {
      case .signin:
        self?.trigger(.signin)
      case .signup:
        self?.trigger(.signup)
      }
    }).disposed(by: bag)
    return module.viewController
  }

  func signin() -> Presentable {
    let module = try! SignInConfigurator.configure(inputData: .init())

    module.moduleOutput.moduleAction.subscribe(onNext: { [weak self] _ in
      self?.trigger(.successLogin)
    }).disposed(by: bag)

    return module.viewController
  }

  func signup() -> Presentable {
    let module = try! SignUpConfigurator.configure(inputData: .init())
    return module.viewController
  }
}
