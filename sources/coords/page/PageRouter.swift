// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

protocol PagerProtocol: class {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
}

class LirikaPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  weak var pagerDataSource: PagerProtocol?
  
  override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
    super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    self.dataSource = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    return pagerDataSource?.pageViewController(pageViewController, viewControllerBefore: viewController)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    return pagerDataSource?.pageViewController(pageViewController, viewControllerAfter: viewController)
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pagerDataSource?.presentationCountForPageViewController(pageViewController: pageViewController) ?? 0
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pagerDataSource?.presentationIndexForPageViewController(pageViewController: pageViewController) ?? 0
  }
}

extension Router where RootContainer: LirikaPage {
  func define(dataSource: PagerProtocol) {
    rootController?.get().pagerDataSource = dataSource
  }
  
  func reset() {
    rootController?.get().pagerDataSource = nil
  }
  
  func set(_ controllers: [UIViewController]?, direction: UIPageViewController.NavigationDirection, animated: Bool, completion: PresentationHandler?) {
    rootController?.get().setViewControllers(controllers, direction: direction, animated: animated, completion: { state in completion?() })
  }
}
