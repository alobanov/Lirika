// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import UIKit.UIFont

class Appearance {
  static func apply() {
    UINavigationBar.appearance().largeTitleTextAttributes = [
      NSAttributedString.Key.foregroundColor: S.colorBlackLight,
      NSAttributedString.Key.font: F.bold(32).font,
    ]
  }
}

class S {
  static let colorBlackLight: UIColor = UIColor(red: 0.169, green: 0.196, blue: 0.231, alpha: 1.000)
  static let colorGreen: UIColor = UIColor(red: 0.000, green: 0.820, blue: 0.584, alpha: 1.000)
  static let colorRed: UIColor = UIColor(red: 1.000, green: 0.323, blue: 0.353, alpha: 1.000)
  static let colorBlue: UIColor = UIColor(red: 0.222, green: 0.477, blue: 0.925, alpha: 1.000)
  static let colorBlueLight: UIColor = UIColor(red: 0.620, green: 0.741, blue: 0.968, alpha: 1.000)
  static let colorViolet: UIColor = UIColor(red: 0.586, green: 0.458, blue: 0.988, alpha: 1.000)
  static let colorGrayDark: UIColor = UIColor(red: 0.565, green: 0.565, blue: 0.565, alpha: 1.000)
  static let colorGray: UIColor = UIColor(red: 0.839, green: 0.839, blue: 0.839, alpha: 1.000)
  static let colorGrayLight: UIColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1.000)
  static let colorOrange: UIColor = UIColor(red: 0.999, green: 0.656, blue: 0.000, alpha: 1.000)
}

enum F {
  case regular(CGFloat), bold(CGFloat)

  var font: UIFont {
    switch self {
    case let .bold(fontSize):
      return UIFont(name: "PTSans-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    case let .regular(fontSize):
      return UIFont(name: "PTSans-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
  }
}
