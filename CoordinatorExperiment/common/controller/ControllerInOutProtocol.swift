// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import Foundation

protocol ControllerInOutType {
  associatedtype Input
  associatedtype Output

  func configure(input: Input) -> Output
}
