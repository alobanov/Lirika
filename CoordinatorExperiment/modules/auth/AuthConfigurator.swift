// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class AuthConfigurator {
  class func configure(inputData: AuthViewModel.ModuleInputData,
                       moduleInput: AuthViewModel.ModuleInput? = nil) throws
    -> (viewController: UIViewController, moduleOutput: AuthViewModel.ModuleOutput) {
    // View controller
    let viewController = createViewController()
    viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)

    // Dependencies
    let dependencies = try createDependencies()

    // View model
    let viewModel = AuthViewModel(dependencies: dependencies, moduleInputData: inputData)
    let moduleOutput = viewModel.configureModule(input: moduleInput)

    viewController.viewModel = viewModel

    return (viewController, moduleOutput)
  }

  private class func createViewController() -> AuthViewController {
    return AuthViewController()
  }

  private class func createDependencies() throws -> AuthViewModel.InputDependencies {
    let dependencies =
      AuthViewModel.InputDependencies()
    return dependencies
  }

  static func module(
    inputData: AuthViewModel.ModuleInputData,
    moduleInput: AuthViewModel.ModuleInput? = nil
  )
    -> (Presentable, AuthViewModel.ModuleOutput)? {
    do {
      let output = try AuthConfigurator.configure(inputData: inputData, moduleInput: moduleInput)
      return (output.viewController, output.moduleOutput)
    } catch let err {
      print(err)
      return nil
    }
  }
}
