// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import RxCocoa
import RxSwift
import UIKit

class SignUpViewController: UIViewController {
  // MARK: - Properties

  // Dependencies
  var viewModel: SignUpViewOutput?

  // Public
  var bag = DisposeBag()

  // Private
  private let viewAppearState = PublishSubject<ViewAppearState>()

  // IBOutlet & UI
  lazy var customView: SignUpView = {
    let customView = SignUpView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    return customView
  }()

  // MARK: - View lifecycle

  override func loadView() {
    view = customView
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
      assertionFailure("Please, set ViewModel as dependency for SignUp")
      return
    }

    let input = SignUpViewModel.Input(appearState: viewAppearState)
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
    print("SignUpViewController dead")
  }
}
