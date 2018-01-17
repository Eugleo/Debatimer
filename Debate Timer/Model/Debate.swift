//
//  Debate.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

struct Debate {
    private var speeches: [Speech]
    private var currentSpeechIndex = 0
    private var affirmativeTimer = Timer()
    private var negativeTimer = Timer()
    private var speechTimer = Timer()

    // A general init to implement other possible debate formats
    init(speeches: [Speech]) {
        self.speeches = speeches
    }

    // A default implementation with classic Debate rules: A1, C, N1, C, A2, C, N2, C, A3, N3
    init() {
        let speeches = [ Speech(speaker1: .A1, timeLimit: 360),
                         Speech(speaker1: .N3, timeLimit: 180,
                                isCrossQuestion: true, speaker2: .A1),
                         Speech(speaker1: .N1, timeLimit: 360),
                         Speech(speaker1: .A3, timeLimit: 180,
                                isCrossQuestion: true, speaker2: .N1),
                         Speech(speaker1: .A2, timeLimit: 360),
                         Speech(speaker1: .N1, timeLimit: 180,
                                isCrossQuestion: true, speaker2: .A2),
                         Speech(speaker1: .N2, timeLimit: 360),
                         Speech(speaker1: .N2, timeLimit: 180, 
                                isCrossQuestion: true, speaker2: .A1),
                         Speech(speaker1: .A3, timeLimit: 360),
                         Speech(speaker1: .N3, timeLimit: 360) ]
        self.speeches = speeches
    }

    mutating func startNextSpeech() {
        let nextIndex = currentSpeechIndex + 1
        guard nextIndex < speeches.count else { return }
        speechTimer.countdown(startingAt: speeches[currentSpeechIndex].timeLimit)
    }

    func allSpeeches() -> [Speech] {
        return speeches
    }

    mutating func stopSpeech() {
        guard currentSpeechIndex < speeches.count else { return }
        speeches[currentSpeechIndex].elapsedTime = speechTimer.elapsedTime
        currentSpeechIndex += 1
        speechTimer.stop()
    }

    func currentSpeechTimeLeft() -> TimeInterval? {
        guard speechTimer.isRunning() else { return nil }
        return ceil(speechTimer.timeLeft)
    }

    func teamTimeLeft() -> [Team: TimeInterval] {
        return [.Affirmative: ceil(affirmativeTimer.timeLeft), .Negative: ceil(negativeTimer.timeLeft)]
    }

    func givenSpeeches() -> [Speech] {
        return Array(speeches.prefix(upTo: currentSpeechIndex))
    }

    mutating func unpauseTimer(forTeam team: Team) {
        if team == .Affirmative {
            affirmativeTimer.unpause()
        } else {
            negativeTimer.unpause()
        }
    }

    mutating func pauseTimer(for team: Team) {
        if team == .Affirmative {
            affirmativeTimer.pause()
        } else {
            negativeTimer.pause()
        }
    }
}
