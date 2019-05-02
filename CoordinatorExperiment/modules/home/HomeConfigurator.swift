// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class HomeConfigurator {
  class func configure(inputData: HomeViewModel.ModuleInputData,
                       moduleInput: HomeViewModel.ModuleInput? = nil) throws
    -> (viewController: UIViewController, moduleOutput: HomeViewModel.ModuleOutput) {
    // View controller
    let viewController = createViewController()

    // Dependencies
    let dependencies = try createDependencies()

    // View model
    let viewModel = HomeViewModel(dependencies: dependencies, moduleInputData: inputData)
    let moduleOutput = viewModel.configureModule(input: moduleInput)

    viewController.viewModel = viewModel

    return (viewController, moduleOutput)
  }

  private class func createViewController() -> HomeViewController {
    return HomeViewController()
  }

  private class func createDependencies() throws -> HomeViewModel.InputDependencies {
    let dependencies =
      HomeViewModel.InputDependencies()
    return dependencies
  }

  static func module(
    inputData: HomeViewModel.ModuleInputData,
    moduleInput: HomeViewModel.ModuleInput? = nil
  )
    -> (UIViewController, HomeViewModel.ModuleOutput)? {
    do {
      let output = try HomeConfigurator.configure(inputData: inputData, moduleInput: moduleInput)
      return (output.viewController, output.moduleOutput)
    } catch let err {
      print(err)
      return nil
    }
  }
}
