// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

class OptionsViewController: UIViewController, ControllerInOutType {
  enum TapEventType {
    case tabbar, navigation, modal, pageAsRoot, pageModal
  }

  struct Output {
    let tabbar: Driver<TapEventType>
  }

  struct Input {}

  // MARK: - Properties

  // Dependencies

  // Public
  var bag = DisposeBag()

  // Private
  let tapRelay = PublishRelay<TapEventType>()

  // IBOutlet & UI
  lazy var customView: OptionsView = {
    let customView = OptionsView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    return customView
  }()

  // MARK: - View lifecycle

  override func loadView() {
    view = customView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.largeTitleDisplayMode = .always
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }

  deinit {
    print("StartViewController dead")
  }

  // MARK: - Configuration

  private func configureUI() {
    customView.makeConstraints(vc: self)
    title = "Choose flow"

    customView.showModalButton.rx.tap.asDriver().drive(onNext: { [weak self] in
      self?.tapRelay.accept(.modal)
    }).disposed(by: bag)

    customView.showTabBarButton.rx.tap.asDriver().drive(onNext: { [weak self] in
      self?.tapRelay.accept(.tabbar)
    }).disposed(by: bag)

    customView.showNavigationButton.rx.tap.asDriver().drive(onNext: { [weak self] in
      self?.tapRelay.accept(.navigation)
    }).disposed(by: bag)

    customView.showPageAsRootButton.rx.tap.asDriver().drive(onNext: { [weak self] in
      self?.tapRelay.accept(.pageAsRoot)
    }).disposed(by: bag)

    customView.showPageAsModalButton.rx.tap.asDriver().drive(onNext: { [weak self] in
      self?.tapRelay.accept(.pageModal)
    }).disposed(by: bag)
  }

  func configure(input: OptionsViewController.Input) -> OptionsViewController.Output {
    return Output(tabbar: tapRelay.asDriver(onErrorJustReturn: .tabbar))
  }
}
