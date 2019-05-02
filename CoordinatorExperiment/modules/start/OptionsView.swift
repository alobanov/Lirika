// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class OptionsView: UIView {
  let showTabBarButton = PerfectButton()
  let showNavigationButton = PerfectButton()
  let showModalButton = PerfectButton()

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
    showTabBarButton.setTitle("Tab Bar Controller".uppercased(), for: .normal)
    showNavigationButton.setTitle("Navigation Controller".uppercased(), for: .normal)
    showModalButton.setTitle("Modal Controller".uppercased(), for: .normal)
  }

  private func addSubviews() {
    [showTabBarButton, showNavigationButton, showModalButton].forEach { addSubview($0) }
  }

  public func makeConstraints(vc: UIViewController) {
    showTabBarButton.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(15)
      make.top.equalTo(vc.view.snp.top).inset(20)
      make.height.equalTo(40)
    }

    showNavigationButton.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(15)
      make.top.equalTo(showTabBarButton.snp.bottom).inset(-20)
      make.height.equalTo(40)
    }

    showModalButton.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(15)
      make.top.equalTo(showNavigationButton.snp.bottom).inset(-20)
      make.height.equalTo(40)
    }
  }
}
