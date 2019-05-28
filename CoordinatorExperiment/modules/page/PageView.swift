// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import SnapKit
import UIKit

class PageView: UIView {
  let buttonFirst = PerfectButton()
  let titlePageLabel = UILabel()

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

    titlePageLabel.font = F.bold(22).font
    titlePageLabel.textColor = .white
    titlePageLabel.numberOfLines = 1
    titlePageLabel.textAlignment = .center
  }

  private func addSubviews() {
    [buttonFirst, titlePageLabel].forEach { addSubview($0) }
  }

  public func makeConstraints(vc: UIViewController) {
    buttonFirst.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(15)
      make.bottom.equalTo(vc.view.safeAreaLayoutGuide.snp.bottom)
      make.height.equalTo(40)
    }

    titlePageLabel.snp.makeConstraints { make in
      make.top.equalTo(vc.view.safeAreaLayoutGuide.snp.top).offset(20)
      make.left.right.equalToSuperview()
    }
  }
}
