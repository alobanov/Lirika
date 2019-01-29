//
//  NewsConfigurator.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright (c) 2019 Lobanov Aleksey. All rights reserved.
//

import UIKit

class NewsConfigurator {
  class func configure(inputData:NewsViewModel.ModuleInputData,
                       moduleInput: NewsViewModel.ModuleInput? = nil) throws
    -> (viewController: UIViewController, moduleOutput:NewsViewModel.ModuleOutput) {
    // View controller
    let viewController = createViewController()
      
    // Dependencies
    let dependencies = try createDependencies()
      
    // View model
    let viewModel = NewsViewModel(dependencies: dependencies, moduleInputData: inputData)
    let moduleOutput = viewModel.configureModule(input: moduleInput)
    
    viewController.viewModel = viewModel
      
    return (viewController, moduleOutput)
  }
  
  private class func createViewController() -> NewsViewController {
    return NewsViewController()
  }
  
  private class func createDependencies() throws -> NewsViewModel.InputDependencies {
    let dependencies =
      NewsViewModel.InputDependencies()
    return dependencies
  }
 
  static func module(
    inputData: NewsViewModel.ModuleInputData,
    moduleInput: NewsViewModel.ModuleInput? = nil)
    -> (UIViewController, NewsViewModel.ModuleOutput)? {
      do {
        let output = try NewsConfigurator.configure(inputData: inputData, moduleInput: moduleInput)
        return (output.viewController, output.moduleOutput)
      } catch let err {
        print(err)
        return nil
      }
  }
}
