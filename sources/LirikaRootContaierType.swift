// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation

protocol LirikaRootContaierType: AnyObject {
  associatedtype Container
  func get() -> Container
}
