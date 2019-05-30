// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import UIKit

class OptionsView: UIView {
  let showTabBarButton = PerfectButton()
  let showNavigationButton = PerfectButton()
  let showModalButton = PerfectButton()
  let showPageAsRootButton = PerfectButton()
  let showPageAsModalButton = PerfectButton()
  let showControllerButton = PerfectButton()

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
    showTabBarButton.setTitle("Tab Bar as ROOT".uppercased(), for: .normal)
    showNavigationButton.setTitle("Push into navigation".uppercased(), for: .normal)
    showModalButton.setTitle("Present modal".uppercased(), for: .normal)
    showPageAsRootButton.setTitle("Page as ROOT".uppercased(), for: .normal)
    showPageAsModalButton.setTitle("Present page as modal".uppercased(), for: .normal)
    showControllerButton.setTitle("Present controller contains page as model", for: .normal)
  }

  private func addSubviews() {
    [showTabBarButton, showNavigationButton, showModalButton, showPageAsRootButton, showPageAsModalButton, showControllerButton].forEach { addSubview($0) }
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

    showPageAsRootButton.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(15)
      make.top.equalTo(showModalButton.snp.bottom).inset(-20)
      make.height.equalTo(40)
    }

    showPageAsModalButton.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(15)
      make.top.equalTo(showPageAsRootButton.snp.bottom).inset(-20)
      make.height.equalTo(40)
    }

    showControllerButton.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(15)
      make.top.equalTo(showPageAsModalButton.snp.bottom).inset(-20)
      make.height.equalTo(40)
    }
  }
}
