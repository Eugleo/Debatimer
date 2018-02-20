//
//  Debate.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

struct Debate {
    // MARK: Properties
    private var speeches: [Speech3]
    private var currentIndex = 0
    private var affirmativeTimer = CountdownTimer()
    private var negativeTimer = CountdownTimer()
    private var speechTimer = CountdownTimer()

    // MARK: Initializers
    // An implementation with defaults according to classic debate rules: A1, X, N1, X, A2, X, N2, X, A3, N3
    init() {
        let crossTimeLimit: TimeInterval = 180
        let a1 = Speech3(speaker1: .A1)
        let n3a1 = Speech3(speaker1: .N3, speaker2: .A1, timeLimit: crossTimeLimit)
        let n1 = Speech3(speaker1: .N1)
        let a3n1 = Speech3(speaker1: .A3, speaker2: .N1, timeLimit: crossTimeLimit)
        let a2 = Speech3(speaker1: .A2)
        let n1a2 = Speech3(speaker1: .N1, speaker2: .A2, timeLimit: crossTimeLimit)
        let n2 = Speech3(speaker1: .N2)
        let a1n2 = Speech3(speaker1: .A1, speaker2: .N2, timeLimit: crossTimeLimit)
        let a3 = Speech3(speaker1: .A3)
        let n3 = Speech3(speaker1: .N3)

        speeches = [a1, n3a1, n1, a3n1, a2, n1a2, n2, a1n2, a3, n3]
    }

    // MARK: Private functions
    mutating func runPrepTime() {
        let lastSpeech = speeches[currentIndex]

        if (lastSpeech.speaker1.team() == .affirmative && lastSpeech.isCross) ||
            (lastSpeech.speaker1.team() == .negative && !lastSpeech.isCross) {

            affirmativeTimer.unpause()
        } else {
            negativeTimer.unpause()
        }

        if currentIndex == speeches.count - 1 {
            affirmativeTimer.pause()
            negativeTimer.pause()
        }
    }

    // MARK: Public functions
    func allSpeeches() -> [Speech3] {
        return speeches
    }

    func allSpeakers() -> [SpeakerID] {
        return speeches
            .map { $0.speaker1 }
            .reduce([]) { acc, s in acc.contains(s) ? acc : acc + [s] }
    }

    func currentSpeaker() -> SpeakerID? {
        guard let currentSpeech = self.currentSpeech() else { return nil }

        return currentSpeech.speaker1
    }

    func currentSpeech() -> Speech3? {
        guard speechTimer.isRunning() else { return nil }

        return speeches[currentIndex]
    }

    func currentSpeechIndex() -> Int? {
        guard speechTimer.isRunning() else { return nil }

        return currentIndex
    }

    func currentSpeechTimeLeft() -> TimeInterval? {
        guard speechTimer.isRunning() else { return nil }

        return speechTimer.timeLeft
    }

    mutating func startSpeech(atIndex index: Int) {
        guard index < speeches.count else { return }

        currentIndex = index
        affirmativeTimer.pause()
        negativeTimer.pause()
        speechTimer.countdown(startingAt: speeches[currentIndex].timeLimit)
    }

    mutating func stopSpeech() -> TimeInterval {
        runPrepTime()

        let measurement = speechTimer.elapsedTime
        speechTimer.stop()
        return measurement
    }

    func teamPreparing() -> Team? {
        if affirmativeTimer.isRunning() {
            return .affirmative
        } else if negativeTimer.isRunning() {
            return .negative
        } else {
            return nil
        }
    }

    func prepTimeLeft() -> (affirmative: TimeInterval, negative: TimeInterval) {
        return (affirmative: affirmativeTimer.timeLeft, negativeTimer.timeLeft)
    }

    mutating func unpauseTimer(forTeam team: Team) {
        if team == .affirmative {
            affirmativeTimer.unpause()
            negativeTimer.pause()
        } else {
            negativeTimer.unpause()
            affirmativeTimer.pause()
        }
    }

    mutating func pauseTimer(for team: Team) {
        if team == .affirmative {
            affirmativeTimer.pause()
        } else {
            negativeTimer.pause()
        }
    }
}
