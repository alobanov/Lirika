// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class AuthView: UIView {
  let signInButton = PerfectButton()
  let signUpButton = PerfectButton()
  let descrLabel = UILabel()

  override init(frame: CGRect = CGRect.zero) {
    super.init(frame: frame)
    configureView()
    addSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func configureView() {
    backgroundColor = .white

    descrLabel.font = F.regular(14).font
    descrLabel.textColor = S.colorBlackLight
    descrLabel.numberOfLines = 0
    descrLabel.text = """
    Simple example of application build
    with MVVM + Rx + Coordinator and ❤️. You can use templates for creating MVVM and coordinators.
    """
    descrLabel.textAlignment = .left
    descrLabel.minimumScaleFactor = 0.3
    descrLabel.adjustsFontSizeToFitWidth = true

    signInButton.setTitle("Login flow".uppercased(), for: .normal)
    signUpButton.setTitle("Registration flow".uppercased(), for: .normal)
  }

  private func addSubviews() {
    [signInButton, signUpButton, descrLabel].forEach { addSubview($0) }
  }

  public func makeConstraints(vc: UIViewController) {
    let defaultOffset = 15

    descrLabel.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview().inset(defaultOffset)
    }

    signUpButton.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(defaultOffset)
      make.height.equalTo(40)
      make.bottom.equalTo(-40)
    }

    signInButton.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(defaultOffset)
      make.height.equalTo(40)
      make.bottom.equalTo(signUpButton.snp.top).offset(-10)
    }
  }
}
