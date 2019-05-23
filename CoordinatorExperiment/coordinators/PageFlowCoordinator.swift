// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum PageFlowRoute: Route {
  case prepareFirstPage, exit, prepareForTabBar(tag: Int)
}

class PageFlowCoordinator: PageCoordinator<PageFlowRoute>, CoordinatorOutput {
  func configure() -> Output {
    return Output(exit: exit.asObservable())
  }
  
  struct Output {
    let exit: Observable<Void>
  }
  
  fileprivate let exit = PublishRelay<Void>()
  
  var pageInTabBar = false
  
  struct Page {
    var title: String
    var buttonTitle: String
    var index: Int
    var color: UIColor
  }
  
  let pages = [
    Page(title: "First page", buttonTitle: "Next", index: 0, color: .red),
    Page(title: "Second page", buttonTitle: "One more next", index: 1, color: .yellow),
    Page(title: "Third page", buttonTitle: "Finish", index: 2, color: .blue),
  ]
  
  override init(container: RootContainerType?, initialRoute: PageFlowRoute? = nil) {
    super.init(container: container, initialRoute: initialRoute)
  }
  
  // MARK: - Overrides
  
  override func prepare(route: PageFlowRoute, completion: PresentationHandler?) {
    switch route {
    case .prepareFirstPage:
      if let controller = viewControllerAtIndex(index: 0)?.presentable() {
        self.router.set([controller], direction: .forward, animated: true, completion: completion)
      }
      
    case let .prepareForTabBar(tag):
      if let controller = viewControllerAtIndex(index: 0)?.presentable() {
        self.router.set([controller], direction: .forward, animated: true, completion: completion)
      }
      pageInTabBar = true
      router.container().presentable().tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: tag)
      
    case .exit:
      if !pageInTabBar {
        router.reset()
      }
      
      exit.accept(())
    }
  }
  
  override func configureRootViewController() {
    router.define(dataSource: self)
  }
  
  func viewControllerAtIndex(index: Int) -> Presentable? {
    if pages.isEmpty || index >= pages.count {
      return nil
    }
    
    return page(model: pages[index])
  }
  
  func goto(index: Int, derection: UIPageViewController.NavigationDirection) {
    guard let controller = viewControllerAtIndex(index: index) else {
      return
    }
    
    DispatchQueue.main.async { [weak self] in
      self?.router.set([controller.presentable()], direction: derection, animated: true, completion: {
        print("Success")
      })
    }
  }
  
  deinit {
    print("Dead PageFlowCoordinator")
  }
}

extension PageFlowCoordinator: LirikaPagerProtocol {
  func pageViewController(_ page: UIPageViewController, controllerBefore: UIViewController) -> UIViewController? {
    guard let controller = controllerBefore as? LirikaPageIndexProtocol else {
      return nil
    }
    
    var index = controller.index
    if index == 0 || index == NSNotFound {
      return nil
    } else {
      index -= 1
    }
    
    return self.viewControllerAtIndex(index: index)?.presentable()
  }
  
  func pageViewController(_ page: UIPageViewController, controllerAfter: UIViewController) -> UIViewController? {
    guard let controller = controllerAfter as? LirikaPageIndexProtocol else {
      return nil
    }
    
    var index = controller.index
    if index == NSNotFound {
      return nil
    }
    
    index += 1
    if index == pages.count {
      return nil
    }
    
    return self.viewControllerAtIndex(index: index)?.presentable()
  }
  
  func presentationCountForPageViewController(page: UIPageViewController) -> Int {
    return pages.count
  }
  
  func presentationIndexForPageViewController(page: UIPageViewController) -> Int {
    return 0
  }
}

extension PageFlowCoordinator {
  fileprivate func page(model: Page) -> Presentable {
    let page = PageViewController()
    let input = PageViewController.Input(
      index: model.index, controllerTitle: model.title,
      buttonTitle: model.buttonTitle, backgroundColor: model.color
    )
    
    let totalPage = pages.count - 1
    
    let output = page.configure(input: input)
    output.tapFirstAction.asDriver().drive(onNext: { [weak self] _ in
      if page.index == totalPage {
        self?.trigger(.exit)
      } else {
        self?.goto(index: page.index+1, derection: .forward)
      }
    }).disposed(by: bag)
    
    return page
  }
}
