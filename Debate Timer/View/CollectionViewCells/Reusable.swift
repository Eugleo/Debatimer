//
//  Reusable.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 20.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

// MARK: Protocol definition
protocol Reusable {
    static var reuseIdentifier: String { get }
}

// MARK: Default implementation
extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
