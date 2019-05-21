// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum PageFlowRoute: Route {
  case prepareFirstPage, exit
}

class PageFlowCoordinator: PageCoordinator<PageFlowRoute>, CoordinatorOutput {
  func configure() -> Output {
    return Output(logout: outputLogout.asObservable())
  }
  
  struct Output {
    let logout: Observable<Void>
  }
  
  fileprivate let outputLogout = PublishRelay<Void>()
  
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
      
    case .exit:
      router.reset()
      outputLogout.accept(())
    }
  }
  
  override func configureRootViewController() {
    router.define(dataSource: self)
  }
  
  func viewControllerAtIndex(index: Int) -> Presentable? {
    if pages.isEmpty || index >= pages.count {
      return nil
    }
    
    let model = pages[index]
    return page(model: model)
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

extension PageFlowCoordinator: PagerProtocol {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let vc = viewController as? LirikaPageIndexProtocol else {
      return nil
    }
    
    var index = vc.index
    if index == 0 || index == NSNotFound {
      return nil
    } else {
      index -= 1
    }
    
    return self.viewControllerAtIndex(index: index)?.presentable()
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let vc = viewController as? LirikaPageIndexProtocol else {
      return nil
    }
    
    var index = vc.index
    if index == NSNotFound {
      return nil
    }
    
    index += 1
    if index == pages.count {
      return nil
    }
    
    return self.viewControllerAtIndex(index: index)?.presentable()
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pages.count
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
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
