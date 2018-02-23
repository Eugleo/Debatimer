// The MIT License (MIT)
//
// Copyright (c) 2018 Alexander Grebenyuk (github.com/kean).

import Foundation

public protocol With {}

extension With where Self: AnyObject {
    public func with(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: With {}
