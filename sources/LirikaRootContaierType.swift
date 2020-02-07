// Copyright (c) 2020 Lobanov Aleksey. All rights reserved.

import Foundation

public protocol LirikaRootContaierType: AnyObject {
  associatedtype Container
  var container: Container { get }
}
