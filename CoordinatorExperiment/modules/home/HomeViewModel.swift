// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift

protocol HomeViewOutput {
  func configure(input: HomeViewModel.Input) -> HomeViewModel.Output
}

class HomeViewModel: RxViewModelType, RxViewModelModuleType, HomeViewOutput {
  // MARK: In/Out struct

  struct InputDependencies {}

  struct Input {
    let appearState: Observable<ViewAppearState>
    let closeSelf: Observable<Void>
  }

  struct Output {
    let title: Observable<String>
    let state: Observable<ModelState>
  }

  // MARK: Dependencies

  private let dp: InputDependencies
  private let moduleInputData: ModuleInputData

  // MARK: Properties

  private let bag = DisposeBag()
  private let modelState: RxViewModelStateProtocol = RxViewModelState()

  // MARK: Observables

  private let title = Observable.just("Home")
  private let outputModuleAction = PublishSubject<OutputModuleActionType>()

  // MARK: - initializer

  init(dependencies: InputDependencies, moduleInputData: ModuleInputData) {
    self.dp = dependencies
    self.moduleInputData = moduleInputData
  }

  // MARK: - HomeViewOutput

  func configure(input: Input) -> Output {
    // Configure input
    input.appearState.subscribe(onNext: { _ in
      // .didLoad and etc
    }).disposed(by: bag)

    input.closeSelf.subscribe(onNext: { [weak self] _ in
      self?.outputModuleAction.onNext(.back)
    }).disposed(by: bag)

    // Configure output
    return Output(
      title: title.asObservable(),
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
    print("-- HomeViewModel dead")
    outputModuleAction.onNext(.deInit)
  }
}
