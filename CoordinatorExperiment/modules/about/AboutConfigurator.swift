//
//  AboutConfigurator.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright (c) 2019 Lobanov Aleksey. All rights reserved.
//

import UIKit

class AboutConfigurator {
  class func configure(inputData:AboutViewModel.ModuleInputData,
                       moduleInput: AboutViewModel.ModuleInput? = nil) throws
    -> (viewController: UIViewController, moduleOutput:AboutViewModel.ModuleOutput) {
    // View controller
    let viewController = createViewController()
      
    // Dependencies
    let dependencies = try createDependencies()
      
    // View model
    let viewModel = AboutViewModel(dependencies: dependencies, moduleInputData: inputData)
    let moduleOutput = viewModel.configureModule(input: moduleInput)
    
    viewController.viewModel = viewModel
      
    return (viewController, moduleOutput)
  }
  
  private class func createViewController() -> AboutViewController {
    return AboutViewController()
  }
  
  private class func createDependencies() throws -> AboutViewModel.InputDependencies {
    let dependencies =
      AboutViewModel.InputDependencies()
    return dependencies
  }
 
  static func module(
    inputData: AboutViewModel.ModuleInputData,
    moduleInput: AboutViewModel.ModuleInput? = nil)
    -> (UIViewController, AboutViewModel.ModuleOutput)? {
      do {
        let output = try AboutConfigurator.configure(inputData: inputData, moduleInput: moduleInput)
        return (output.viewController, output.moduleOutput)
      } catch let err {
        print(err)
        return nil
      }
  }
}
