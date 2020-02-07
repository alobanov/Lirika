// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import SnapKit
import UIKit

class ButtonsView: UIView {
  let buttonFirst = PerfectButton()
  let buttonSecond = PerfectButton()

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
  }

  private func addSubviews() {
    [buttonFirst, buttonSecond].forEach { addSubview($0) }
  }

  public func makeConstraints(vc: UIViewController) {
    buttonFirst.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(15)
      make.top.equalTo(vc.view.snp.top).inset(20)
      make.height.equalTo(40)
    }

    buttonSecond.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(15)
      make.top.equalTo(buttonFirst.snp.bottom).offset(15)
      make.height.equalTo(40)
    }
  }
}
