// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

class PageViewController: UIViewController, ControllerInOutType, LirikaPageIndexProtocol {
  struct Output {
    let tapFirstAction: Driver<Void>
    let didDeinit: Driver<Void>
  }

  struct Input {
    let index: Int
    let controllerTitle: String
    let buttonTitle: String
    let backgroundColor: UIColor
  }

  // MARK: - Properties

  // Dependencies

  // Public
  var bag = DisposeBag()
  private(set) var index: Int = 0

  // Private
  let didDeinit = PublishRelay<Void>()

  // IBOutlet & UI
  lazy var customView: PageView = {
    let customView = PageView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
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
    print("====== PageViewController dead")
  }

  // MARK: - Configuration

  private func configureUI() {
    customView.makeConstraints(vc: self)
  }

  func configure(input: Input) -> Output {
    customView.titlePageLabel.text = input.controllerTitle
    index = input.index
    view.backgroundColor = input.backgroundColor
    customView.buttonFirst.setTitle(input.buttonTitle.uppercased(), for: .normal)

    return Output(
      tapFirstAction: customView.buttonFirst.rx.tap.asDriver(),
      didDeinit: didDeinit.asDriver(onErrorJustReturn: ())
    )
  }
}
