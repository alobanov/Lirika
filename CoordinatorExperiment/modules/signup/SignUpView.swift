//
//  SignUpView.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 27/01/2019.
//  Copyright (c) 2019 Lobanov Aleksey. All rights reserved.
//

import UIKit

class SignUpView: UIView {
  let quickSignUpButton = PerfectButton()
  
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
    quickSignUpButton.setTitle("Quick sign up".uppercased(), for: .normal)
  }
  
  private func addSubviews() {
    [quickSignUpButton].forEach { addSubview($0) }
  }
  
  public func makeConstraints(vc: UIViewController) {
    quickSignUpButton.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(15)
      make.centerY.equalToSuperview()
      make.height.equalTo(40)
    }
  }
}
