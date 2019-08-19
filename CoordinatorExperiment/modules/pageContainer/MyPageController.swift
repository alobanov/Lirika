// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

protocol PageFlowProtocol: AnyObject {
  func pageList() -> [PageFlowCoordinator.Page]
  func page(model: PageFlowCoordinator.Page) -> Presentable
  func viewControllerAtIndex(index: Int) -> Presentable?
}

class MyPageController: LirikaPage.Container, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  weak var pageFlowDelegate: PageFlowProtocol?

  init() {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    self.dataSource = self
    self.delegate = self
  }

  override func viewDidLoad() {
    setupPageControl()
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let controller = viewController as? LirikaPageIndexProtocol else {
      return nil
    }

    var index = controller.index
    if index == 0 || index == NSNotFound {
      return nil
    } else {
      index -= 1
    }

    return pageFlowDelegate?.viewControllerAtIndex(index: index)?.presentable()
  }

  func setupPageControl() {
    let pageControl = UIPageControl.appearance()
    pageControl.pageIndicatorTintColor = .lightGray
    pageControl.currentPageIndicatorTintColor = .black
    pageControl.backgroundColor = .white
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let controller = viewController as? LirikaPageIndexProtocol else {
      return nil
    }

    var index = controller.index
    if index == NSNotFound {
      return nil
    }

    index += 1
    if index == pageFlowDelegate?.pageList().count {
      return nil
    }

    return pageFlowDelegate?.viewControllerAtIndex(index: index)?.presentable()
  }

  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return pageFlowDelegate?.pageList().count ?? 0
  }

  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return 0
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
