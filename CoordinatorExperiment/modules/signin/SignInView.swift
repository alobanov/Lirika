//
//  SignInView.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 27/01/2019.
//  Copyright (c) 2019 Lobanov Aleksey. All rights reserved.
//

import UIKit

class SignInView: UIView {
  
  let loginTextField = UITextField()
  let passTextField = UITextField()
  let descrLabel = UILabel()
  let enterButton = PerfectButton()
  
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
    
    descrLabel.font = F.bold(16).font
    descrLabel.textColor = S.colorGray
    descrLabel.numberOfLines = 0
    descrLabel.text = """
    Enter any login and password:
    """
    descrLabel.textAlignment = .left
    descrLabel.minimumScaleFactor = 0.3
    descrLabel.adjustsFontSizeToFitWidth = true
    
    [loginTextField,
     passTextField].forEach{
      $0.font = F.bold(20).font
      $0.layer.cornerRadius = 8.0
      $0.layer.masksToBounds = true
      $0.backgroundColor = S.colorGrayLight
      $0.textAlignment = .center
      $0.textColor = S.colorGrayDark
    }

    loginTextField.placeholder = "Login"
    
    passTextField.placeholder = "Password"
    passTextField.isSecureTextEntry = true
    
    enterButton.setTitle("Enter".uppercased(), for: .normal)
  }
  
  private func addSubviews() {
    [loginTextField, passTextField, descrLabel, enterButton].forEach { addSubview($0) }
  }
  
  public func makeConstraints(vc: UIViewController) {
    let defaultOffset = 15
    
    descrLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(defaultOffset)
      make.centerX.equalToSuperview()
    }
    
    loginTextField.snp.makeConstraints { make in
      make.top.equalTo(descrLabel.snp.bottom).offset(10)
      make.left.right.equalToSuperview().inset(defaultOffset)
      make.height.equalTo(40)
    }
    
    passTextField.snp.makeConstraints { make in
      make.top.equalTo(loginTextField.snp.bottom).offset(10)
      make.left.right.equalToSuperview().inset(defaultOffset)
      make.height.equalTo(40)
    }
    
    enterButton.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(defaultOffset)
      make.height.equalTo(40)
      make.top.equalTo(passTextField.snp.bottom).offset(20)
    }
  }
}
