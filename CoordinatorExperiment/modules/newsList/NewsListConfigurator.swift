// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class NewsListConfigurator {
  class func configure(inputData: NewsListViewModel.ModuleInputData,
                       moduleInput: NewsListViewModel.ModuleInput? = nil) throws
    -> (viewController: UIViewController, moduleOutput: NewsListViewModel.ModuleOutput) {
    // View controller
    let viewController = createViewController()
    viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

    // Dependencies
    let dependencies = try createDependencies()

    // View model
    let viewModel = NewsListViewModel(dependencies: dependencies, moduleInputData: inputData)
    let moduleOutput = viewModel.configureModule(input: moduleInput)

    viewController.viewModel = viewModel

    return (viewController, moduleOutput)
  }

  private class func createViewController() -> NewsListViewController {
    return NewsListViewController()
  }

  private class func createDependencies() throws -> NewsListViewModel.InputDependencies {
    let dependencies =
      NewsListViewModel.InputDependencies()
    return dependencies
  }

  static func module(
    inputData: NewsListViewModel.ModuleInputData,
    moduleInput: NewsListViewModel.ModuleInput? = nil
  )
    -> (UIViewController, NewsListViewModel.ModuleOutput)? {
    do {
      let output = try NewsListConfigurator.configure(inputData: inputData, moduleInput: moduleInput)
      return (output.viewController, output.moduleOutput)
    } catch let err {
      print(err)
      return nil
    }
  }
}
