//
//  Speaker.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

enum Team: String {
    case Affirmative, Negative
}

enum Speaker: String {
    case A1, A2, A3, N1, N2, N3

    func team() -> Team {
        switch self {
        case .A1, .A2, .A3:
            return .Affirmative
        case .N1, .N2, .N3:
            return .Negative
        }
    }
}
