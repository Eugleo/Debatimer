//
//  Speech.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 16.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

struct Speech {

    // MARK: - Properties

    let speaker1: SpeakerID
    let speaker2: SpeakerID?
    let isCross: Bool
    let timeLimit: TimeInterval

    // MARK: - Initialization
    
    init(speaker1: SpeakerID, speaker2: SpeakerID? = nil, timeLimit: TimeInterval? = nil) {
        self.speaker1 = speaker1
        self.speaker2 = speaker2
        self.isCross = speaker2 != nil
        self.timeLimit = timeLimit ?? speaker1.timeLimit()
    }
}
