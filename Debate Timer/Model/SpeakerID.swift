//
//  SpeakerID.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

enum Team: String {
    case affirmative, negative

    func preparationTime() -> TimeInterval {
        switch self {
            case .affirmative:
                return 300
            case .negative:
                return 420
        }
    }
}

enum SpeakerID: String {
    case A1, A2, A3, N1, N2, N3

    func team() -> Team {
        switch self {
        case .A1, .A2, .A3:
            return .affirmative
        case .N1, .N2, .N3:
            return .negative
        }
    }

    func timeLimit() -> TimeInterval {
        switch self {
        case .A1, .A2, .N1, .N2:
            return 360
        case .A3, .N3:
            return 300
        }
    }
}

final class Speaker {
    // MARK: Properties
    let id: SpeakerID
    var speechTime: TimeInterval?
    var crossTime: TimeInterval?

    // MARK: Initializers
    init(id: SpeakerID) {
        self.id = id
    }
}
