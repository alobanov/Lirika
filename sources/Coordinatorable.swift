// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import Foundation

public protocol Route {}

public protocol Coordinatorable: Presentable {
  func start()
  func deepLink(link: DeepLink)
}

public protocol CoordinatorInput {
  associatedtype InputData
  func define(data: InputData)
}

public protocol CoordinatorInOut {
  associatedtype Output
  associatedtype Input
  func configure(input: Input) -> Output
}
