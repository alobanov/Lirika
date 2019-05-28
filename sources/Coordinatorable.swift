// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation

protocol Route {}

protocol Coordinatorable: Presentable {
  func start()
  func deepLink(link: DeepLink)
}

protocol CoordinatorInput {
  associatedtype InputData
  associatedtype Dependencies

  func define(data: InputData, dp: Dependencies)
}

protocol CoordinatorOutput {
  associatedtype Output
  func configure() -> Output
}
