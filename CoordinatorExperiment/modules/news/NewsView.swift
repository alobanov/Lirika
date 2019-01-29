//
//  NewsView.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright (c) 2019 Lobanov Aleksey. All rights reserved.
//

import UIKit

class NewsView: UIView {
  
  override init(frame: CGRect = CGRect.zero) {
    super.init(frame: frame)
    configureView()
    addSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func configureView() {
    backgroundColor = UIColor.gray
  }
  
  private func addSubviews() {
    
  }
  
  public func makeConstraints(vc: UIViewController) {
    
  }
}
