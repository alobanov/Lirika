// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

protocol LirikaPagerProtocol: class {
  func pageViewController(_ page: UIPageViewController, controllerBefore: UIViewController) -> UIViewController?
  func pageViewController(_ page: UIPageViewController, controllerAfter: UIViewController) -> UIViewController?
  func presentationCountForPageViewController(page: UIPageViewController) -> Int
  func presentationIndexForPageViewController(page: UIPageViewController) -> Int
}

class LirikaPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  weak var pagerDataSource: LirikaPagerProtocol?
  
  override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
    super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    self.dataSource = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    return pagerDataSource?.pageViewController(pageViewController, controllerBefore: viewController)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    return pagerDataSource?.pageViewController(pageViewController, controllerAfter: viewController)
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pagerDataSource?.presentationCountForPageViewController(page: pageViewController) ?? 0
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pagerDataSource?.presentationIndexForPageViewController(page: pageViewController) ?? 0
  }
}

extension Router where RootContainer: LirikaPage {
  func container() -> LirikaPage.Container {
    return rootController?.get() ?? LirikaPage.Container()
  }
  
  func define(dataSource: LirikaPagerProtocol) {
    container().pagerDataSource = dataSource
  }
  
  func reset() {
    container().pagerDataSource = nil
  }
  
  func set(_ controllers: [UIViewController]?, direction: UIPageViewController.NavigationDirection, animated: Bool, completion: PresentationHandler?) {
    container().setViewControllers(controllers, direction: direction, animated: animated, completion: { state in completion?() })
  }
}
