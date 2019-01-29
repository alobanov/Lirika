//
//  PerfectButton.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 27/01/2019.
//  Copyright © 2019 Lobanov Aleksey. All rights reserved.
//

import Foundation
import SimpleButton

class CommonHelper {
  class func delay(_ delay: Double, closure: @escaping () -> Void) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when) {
      // Your code with delay
      closure()
    }
  }
}

class PerfectButton: SimpleButton {
  override func configureButtonStyles() {
    super.configureButtonStyles()
    setTitleColor(.blue, for: .normal)
    titleLabel?.font = F.bold(14).font
    setCornerRadius(8)
    setTitleColor(.white, for: .normal)
    setBackgroundColor(S.colorBlue, for: .normal, animated: true, animationDuration: 0.3)
    setBackgroundColor(S.colorBlueLight, for: .highlighted, animated: true, animationDuration: 0.3)
    
//    setShadowRadius(10, for: .normal, animated: true)
//    setShadowColor(S.colorBlackLight, for: .normal)
//    setShadowOpacity(0.2, for: .normal, animated: true)
//    setShadowOffset(CGSize(width: 0, height: 5), for: .normal, animated: true)
  }
}
