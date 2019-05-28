// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

class ButtonsViewController: UIViewController, ControllerInOutType {
  struct Output {
    let tapFirstAction: Driver<Void>
    let tabSecondAction: Driver<Void>
    let didDeinit: Driver<Void>
  }

  struct Input {
    let controllerTitle: String
    let buttonTitle: String
    let isFirstInStackController: Bool
  }

  // MARK: - Properties

  // Dependencies

  // Public
  var bag = DisposeBag()

  // Private
  let didDeinit = PublishRelay<Void>()

  // IBOutlet & UI
  lazy var customView: ButtonsView = {
    let customView = ButtonsView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
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
    didDeinit.accept(())
    print("SingleButtonViewController dead")
  }

  // MARK: - Configuration

  private func configureUI() {
    customView.makeConstraints(vc: self)
  }

  func configure(input: Input) -> Output {
    navigationItem.largeTitleDisplayMode = .never

    title = input.controllerTitle
    customView.buttonFirst.setTitle(input.buttonTitle.uppercased(), for: .normal)
    customView.buttonSecond.setTitle("POP", for: .normal)

    return Output(
      tapFirstAction: customView.buttonFirst.rx.tap.asDriver(),
      tabSecondAction: customView.buttonSecond.rx.tap.asDriver(),
      didDeinit: didDeinit.asDriver(onErrorJustReturn: ())
    )
  }
}
