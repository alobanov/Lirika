//
//  AboutViewController.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright (c) 2019 Lobanov Aleksey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AboutViewController: UIViewController {
  
  // MARK: - Properties
  
  // Dependencies
  var viewModel: AboutViewOutput?
  
  // Public
  var bag = DisposeBag()
  
  // Private
  private let viewAppearState = PublishSubject<ViewAppearState>()
  
  // IBOutlet & UI
  lazy var customView: AboutView = {
    let customView = AboutView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    return customView
  }()
  
  // MARK: - View lifecycle
  override func loadView() {
    self.view = customView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureRx()
    viewAppearState.onNext(.didLoad)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewAppearState.onNext(.willAppear)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewAppearState.onNext(.didAppear)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewAppearState.onNext(.willDisappear)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    viewAppearState.onNext(.didDisappear)
  }
  
  // MARK: - Configuration
  private func configureRx() {
    guard let model = viewModel else {
      assertionFailure("Please, set ViewModel as dependency for About")
      return
    }
    
    let input = AboutViewModel.Input(appearState: viewAppearState, showSomething: customView.button.rx.tap.asObservable())
    let output = model.configure(input: input)
    
    output.title.subscribe(onNext: { [weak self] str in
      self?.navigationItem.title = str
    }).disposed(by: bag)
  }
  
  private func configureUI() {
    customView.makeConstraints(vc: self)
  }
  
  // MARK: - Additional
  
  deinit {
    print("AboutViewController dead")
  }
  
//  let simpleOver = SimpleOver()
//
//  func navigationController(
//    _ navigationController: UINavigationController,
//    animationControllerFor operation: UINavigationController.Operation,
//    from fromVC: UIViewController,
//    to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//    simpleOver.popStyle = (operation == .push)
//    return simpleOver
//  }
}
