//
//  LoginConfigurator.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright (c) 2019 Lobanov Aleksey. All rights reserved.
//

import UIKit

class LoginConfigurator {
  class func configure(inputData:LoginViewModel.ModuleInputData,
                       moduleInput: LoginViewModel.ModuleInput? = nil) throws
    -> (viewController: UIViewController, moduleOutput:LoginViewModel.ModuleOutput) {
    // View controller
    let viewController = createViewController()
      
    // Dependencies
    let dependencies = try createDependencies()
      
    // View model
    let viewModel = LoginViewModel(dependencies: dependencies, moduleInputData: inputData)
    let moduleOutput = viewModel.configureModule(input: moduleInput)
    
    viewController.viewModel = viewModel
      
    return (viewController, moduleOutput)
  }
  
  private class func createViewController() -> LoginViewController {
    return LoginViewController()
  }
  
  private class func createDependencies() throws -> LoginViewModel.InputDependencies {
    let dependencies =
      LoginViewModel.InputDependencies()
    return dependencies
  }
 
  static func module(
    inputData: LoginViewModel.ModuleInputData,
    moduleInput: LoginViewModel.ModuleInput? = nil)
    -> (UIViewController, LoginViewModel.ModuleOutput)? {
      do {
        let output = try LoginConfigurator.configure(inputData: inputData, moduleInput: moduleInput)
        return (output.viewController, output.moduleOutput)
      } catch let err {
        print(err)
        return nil
      }
  }
}
