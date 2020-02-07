// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum PageFlowRoute: Route {
  case prepareFirstPage, exit, prepareForTabBar(tag: Int)
}

class PageFlowCoordinator: PageCoordinator<PageFlowRoute>, CoordinatorInOut, PageFlowProtocol {
  func pageList() -> [PageFlowCoordinator.Page] {
    return pages
  }

  func configure(input: Input = .init()) -> Output {
    return Output(exit: exit.asObservable())
  }

  struct Input {}

  struct Output {
    let exit: Observable<Void>
  }

  fileprivate let exit = PublishRelay<Void>()
  fileprivate let bag = DisposeBag()

  struct Page {
    var title: String
    var buttonTitle: String
    var index: Int
    var color: UIColor
  }

  let pages = [
    Page(title: "First page", buttonTitle: "Next", index: 0, color: .red),
    Page(title: "Second page", buttonTitle: "One more next", index: 1, color: .yellow),
    Page(title: "Third page", buttonTitle: "n", index: 2, color: .blue),
    Page(title: "Fourth page", buttonTitle: "n", index: 3, color: .gray),
    Page(title: "Fifth page", buttonTitle: "Finish", index: 4, color: .cyan),
  ]

  // MARK: - Overrides

  override func drive(route: PageFlowRoute, completion: PresentationHandler?) {
    switch route {
    case .prepareFirstPage:
      if let controller = viewControllerAtIndex(index: 0)?.presentable() {
        router.set([controller], direction: .forward, animated: true, completion: completion)
      }

    case let .prepareForTabBar(tag):
      if let controller = viewControllerAtIndex(index: 0)?.presentable() {
        router.set([controller], direction: .forward, animated: true, completion: completion)
      }
      router.container().presentable().tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: tag)

    case .exit:
      exit.accept(())
    }
  }

  override func configureRootViewController() {
    guard let page = router.container() as? MyPageController else {
      return
    }

    page.pageFlowDelegate = self
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

extension PageFlowCoordinator {
  internal func page(model: Page) -> Presentable {
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
        self?.goto(index: page.index + 1, derection: .forward)
      }
    }).disposed(by: bag)

    return page
  }
}
