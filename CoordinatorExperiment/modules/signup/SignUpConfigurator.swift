// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class SignUpConfigurator {
  class func configure(inputData: SignUpViewModel.ModuleInputData,
                       moduleInput: SignUpViewModel.ModuleInput? = nil) throws
    -> (viewController: UIViewController, moduleOutput: SignUpViewModel.ModuleOutput) {
    // View controller
    let viewController = createViewController()

    // Dependencies
    let dependencies = try createDependencies()

    // View model
    let viewModel = SignUpViewModel(dependencies: dependencies, moduleInputData: inputData)
    let moduleOutput = viewModel.configureModule(input: moduleInput)

    viewController.viewModel = viewModel

    return (viewController, moduleOutput)
  }

  private class func createViewController() -> SignUpViewController {
    return SignUpViewController()
  }

  private class func createDependencies() throws -> SignUpViewModel.InputDependencies {
    let dependencies =
      SignUpViewModel.InputDependencies()
    return dependencies
  }

  static func module(
    inputData: SignUpViewModel.ModuleInputData,
    moduleInput: SignUpViewModel.ModuleInput? = nil
  )
    -> (Presentable, SignUpViewModel.ModuleOutput)? {
    do {
      let output = try SignUpConfigurator.configure(inputData: inputData, moduleInput: moduleInput)
      return (output.viewController, output.moduleOutput)
    } catch let err {
      print(err)
      return nil
    }
  }
}
