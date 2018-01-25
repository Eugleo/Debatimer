//
//  Speech.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 16.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

struct Speech {
    let isCrossQuestion: Bool
    let speaker1: Speaker
    let speaker2: Speaker?
    let timeLimit: TimeInterval

    init(speaker1: Speaker, speaker2: Speaker? = nil, timeLimit: TimeInterval) {
        self.speaker1 = speaker1
        self.timeLimit = timeLimit
        self.isCrossQuestion = speaker2 != nil
        self.speaker2 = speaker2
    }
}

extension Speech: Equatable {
    static func ==(lhs: Speech, rhs: Speech) -> Bool {
        return
            lhs.speaker1 == rhs.speaker1 &&
            lhs.speaker2 == rhs.speaker2 &&
            lhs.isCrossQuestion == rhs.isCrossQuestion &&
            lhs.timeLimit == rhs.timeLimit
    }
}
