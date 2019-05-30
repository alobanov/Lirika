// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

public protocol LirikaPagerProtocol: AnyObject {
  func pageViewController(_ page: UIPageViewController, controllerBefore: UIViewController) -> UIViewController?
  func pageViewController(_ page: UIPageViewController, controllerAfter: UIViewController) -> UIViewController?
  func presentationCountForPageViewController(page: UIPageViewController) -> Int
  func presentationIndexForPageViewController(page: UIPageViewController) -> Int
  func pageViewController(_ page: UIPageViewController, finished: Bool, previousViewControllers: [UIViewController], completed: Bool)
}

open class LirikaPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  public weak var pagerDataSource: LirikaPagerProtocol?

  public init(style: UIPageViewController.TransitionStyle, orientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]? = nil) {
    super.init(transitionStyle: style, navigationOrientation: orientation, options: options)
    self.dataSource = self
    self.delegate = self
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    return pagerDataSource?.pageViewController(pageViewController, controllerBefore: viewController)
  }

  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    return pagerDataSource?.pageViewController(pageViewController, controllerAfter: viewController)
  }

  public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pagerDataSource?.presentationCountForPageViewController(page: pageViewController) ?? 0
  }

  public func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pagerDataSource?.presentationIndexForPageViewController(page: pageViewController) ?? 0
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    pagerDataSource?.pageViewController(pageViewController, finished: finished, previousViewControllers: previousViewControllers, completed: completed)
  }
}

public extension Router where RootContainer: LirikaPage {
  func container() -> LirikaPage.Container {
    return rootController?.container ?? LirikaPage.Container(style: .scroll, orientation: .horizontal)
  }

  func define(dataSource: LirikaPagerProtocol) {
    container().pagerDataSource = dataSource
  }

  func reset() {
    container().pagerDataSource = nil
  }

  func set(_ controllers: [UIViewController]?, direction: UIPageViewController.NavigationDirection, animated: Bool, completion: PresentationHandler?) {
    container().setViewControllers(controllers, direction: direction, animated: animated, completion: { _ in completion?() })
  }
}
