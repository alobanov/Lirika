//
//  SignInConfigurator.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 27/01/2019.
//  Copyright (c) 2019 Lobanov Aleksey. All rights reserved.
//

import UIKit

class SignInConfigurator {
  class func configure(inputData:SignInViewModel.ModuleInputData,
                       moduleInput: SignInViewModel.ModuleInput? = nil) throws
    -> (viewController: UIViewController, moduleOutput:SignInViewModel.ModuleOutput) {
    // View controller
    let viewController = createViewController()
      
    // Dependencies
    let dependencies = try createDependencies()
      
    // View model
    let viewModel = SignInViewModel(dependencies: dependencies, moduleInputData: inputData)
    let moduleOutput = viewModel.configureModule(input: moduleInput)
    
    viewController.viewModel = viewModel
      
    return (viewController, moduleOutput)
  }
  
  private class func createViewController() -> SignInViewController {
    return SignInViewController()
  }
  
  private class func createDependencies() throws -> SignInViewModel.InputDependencies {
    let dependencies =
      SignInViewModel.InputDependencies()
    return dependencies
  }
 
  static func module(
    inputData: SignInViewModel.ModuleInputData,
    moduleInput: SignInViewModel.ModuleInput? = nil)
    -> (Presentable, SignInViewModel.ModuleOutput)? {
      do {
        let output = try SignInConfigurator.configure(inputData: inputData, moduleInput: moduleInput)
        return (output.viewController, output.moduleOutput)
      } catch let err {
        print(err)
        return nil
      }
  }
}
