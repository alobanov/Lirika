//
//  AboutView.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright (c) 2019 Lobanov Aleksey. All rights reserved.
//

import UIKit

class AboutView: UIView {
  
  let button = UIButton(type: UIButton.ButtonType.infoDark)
  
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
    button.setTitle("Show something", for: .normal)
  }
  
  private func addSubviews() {
    addSubview(button)
  }
  
  public func makeConstraints(vc: UIViewController) {
    button.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
}
