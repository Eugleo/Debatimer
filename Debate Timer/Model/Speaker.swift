//
//  Speaker.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

enum Team: String {
    case affirmative, negative

    func timeLimit() -> TimeInterval {
        switch self {
            case .affirmative:
                return 300
            case .negative:
                return 420
        }
    }
}

final class Speaker {
    let position: Int
    let team: Team
    var speechTime: TimeInterval?
    var crossQuestionsTime: TimeInterval?

    init(position: Int, team: Team) {
        self.position = position
        self.team = team
        self.speechTime = nil
        self.crossQuestionsTime = nil
    }
}

extension Speaker: Equatable {
    static func ==(lhs: Speaker, rhs: Speaker) -> Bool {
        return
            lhs.position == rhs.position &&
            lhs.team == rhs.team &&
            lhs.speechTime == rhs.speechTime &&
            lhs.crossQuestionsTime == rhs.crossQuestionsTime
    }
}
