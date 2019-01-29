//
//  SignInViewModel.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 27/01/2019.
//  Copyright (c) 2019 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignInViewOutput {
  func configure(input: SignInViewModel.Input) -> SignInViewModel.Output
}

class SignInViewModel: RxViewModelType, RxViewModelModuleType, SignInViewOutput {
  
  // MARK: In/Out struct
  struct InputDependencies {
    
  }
  
  struct Input {
    let appearState: Observable<ViewAppearState>
    let tryLogin: Driver<Void>
  }
  
  struct Output {
    let title: Driver<String>
    let state: Observable<ModelState>
  }
  
  // MARK: Dependencies
  private let dp: InputDependencies
  private let moduleInputData: ModuleInputData
  
  // MARK: Properties
  private let bag = DisposeBag()
  private let modelState: RxViewModelStateProtocol = RxViewModelState()
  
  // MARK: Observables
  private let title = Driver.just("Sign In")
  private let outputModuleAction = PublishSubject<OutputModuleActionType>()
  
  // MARK: - initializer
  
  init(dependencies: InputDependencies, moduleInputData: ModuleInputData) {
    self.dp = dependencies
    self.moduleInputData = moduleInputData
  }
  
  // MARK: - SignInViewOutput
  
  func configure(input: Input) -> Output {
    // Configure input
    input.appearState.subscribe(onNext: { _ in
      // .didLoad and etc
    }).disposed(by: bag)
    
    input.tryLogin.drive(onNext: { [weak self] _ in
      self?.outputModuleAction.onNext(.successSignIn)
    }).disposed(by: bag)
    
    // Configure output
    return Output(
      title: title,
      state: modelState.state.asObservable()
    )
  }
  
  // MARK: - Module configuration
  
  func configureModule(input: ModuleInput?) -> ModuleOutput {
    // Configure input signals
    
    // Configure module output
    return ModuleOutput(
      moduleAction: outputModuleAction.asObservable()
    )
  }
  
  // MARK: - Additional

  deinit {
    print("-- SignInViewModel dead")
  }
}
