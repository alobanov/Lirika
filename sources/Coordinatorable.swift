// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation

public protocol Route {}

public protocol Coordinatorable: Presentable {
  func start()
  func deepLink(link: DeepLink)
}

public protocol CoordinatorInput {
  associatedtype InputData
  associatedtype Dependencies

  func define(data: InputData, dp: Dependencies)
}

public protocol CoordinatorOutput {
  associatedtype Output
  func configure() -> Output
}
