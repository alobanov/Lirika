// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation

protocol LirikaRootContaierType: AnyObject {
  associatedtype RootContainer
  func rootContainer() -> RootContainer
}
