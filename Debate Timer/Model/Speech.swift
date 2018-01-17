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
    var elapsedTime: TimeInterval?
    let timeLimit: TimeInterval

    init(speaker1: Speaker, timeLimit: TimeInterval, isCrossQuestion: Bool = false, speaker2: Speaker? = nil) {
        self.speaker1 = speaker1
        self.timeLimit = timeLimit
        self.isCrossQuestion = isCrossQuestion
        self.speaker2 = speaker2
    }
}
