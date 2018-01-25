//
//  Debate.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

final class Debate {
    private var speakers: [Speaker]
    private var speeches: [Speech]
    private var currentSpeechIndex = 0
    private var affirmativeTimer = CountdownTimer()
    private var negativeTimer = CountdownTimer()
    private var speechTimer = CountdownTimer()

    // A general init to implement other possible debate formats
    init(speakers: [Speaker], speeches: [Speech]) {
        self.speakers = speakers
        self.speeches = speeches
    }

    // A default implementation with classic Debate rules: A1, C, N1, C, A2, C, N2, C, A3, N3
    init() {
        let a1 = Speaker(position: 1, team: .affirmative)
        let a2 = Speaker(position: 2, team: .affirmative)
        let a3 = Speaker(position: 3, team: .affirmative)
        let n1 = Speaker(position: 1, team: .negative)
        let n2 = Speaker(position: 2, team: .negative)
        let n3 = Speaker(position: 3, team: .negative)

        let speeches = [ Speech(speaker1: a1, timeLimit: 360),
                         Speech(speaker1: n3, speaker2: a1, timeLimit: 180),
                         Speech(speaker1: n1, timeLimit: 360),
                         Speech(speaker1: a3, speaker2: n1, timeLimit: 180),
                         Speech(speaker1: a2, timeLimit: 360),
                         Speech(speaker1: n1, speaker2: a2, timeLimit: 180),
                         Speech(speaker1: n2, timeLimit: 360),
                         Speech(speaker1: a1, speaker2: n2, timeLimit: 180),
                         Speech(speaker1: a3, timeLimit: 360),
                         Speech(speaker1: n3, timeLimit: 360) ]
        self.speakers = [a1, n1, a2, n2, a3, n3]
        self.speeches = speeches

        affirmativeTimer.countdown(startingAt: Team.affirmative.timeLimit())
        negativeTimer.countdown(startingAt: Team.negative.timeLimit())
        affirmativeTimer.pause()
        negativeTimer.pause()
    }

    private func refreshCurrentSpeaker() {
        guard currentSpeechIndex < speeches.count else { return }

        let currentSpeech = speeches[currentSpeechIndex]
        let currentSpeaker = speakers.first(where: {$0 == currentSpeech.speaker1})!
        let elapsedTime = ceil(speechTimer.elapsedTime) == 0 ? nil : ceil(speechTimer.elapsedTime)
        if currentSpeech.isCrossQuestion {
            currentSpeaker.crossQuestionsTime = elapsedTime
        } else {
            currentSpeaker.speechTime = elapsedTime
        }
    }

    func startSpeech(atIndex index: Int) {
        guard index < speeches.count else { return }
        currentSpeechIndex = index
        affirmativeTimer.pause()
        negativeTimer.pause()
        speechTimer.countdown(startingAt: speeches[currentSpeechIndex].timeLimit)
    }

    func allSpeeches() -> [Speech] {
        refreshCurrentSpeaker() 
        return speeches
    }

    func stopSpeech() {
        guard currentSpeechIndex < speeches.count else { return }

        let lastSpeech = speeches[currentSpeechIndex]
        if (lastSpeech.speaker1.team == .affirmative && lastSpeech.isCrossQuestion) ||
            (lastSpeech.speaker1.team == .negative && !lastSpeech.isCrossQuestion) {
            affirmativeTimer.unpause()
        } else {
            negativeTimer.unpause()
        }

        refreshCurrentSpeaker()
        currentSpeechIndex += 1
        speechTimer.stop()
    }

    func currentSpeechTimeLeft() -> TimeInterval? {
        guard speechTimer.isRunning() else { return nil }
        return floor(speechTimer.timeLeft)
    }

    func currentSpeechTime() -> TimeInterval? {
        guard speechTimer.isRunning() else { return nil }
        return ceil(speechTimer.elapsedTime)
    }

    func teamTimeLeft() -> (affirmative: TimeInterval, negative: TimeInterval) {
        return (affirmative: round(affirmativeTimer.timeLeft), negative: round(negativeTimer.timeLeft))
    }

    func currentSpeaker() -> Speaker? {
        guard speechTimer.isRunning() else { return nil }

        refreshCurrentSpeaker()
        return speeches[currentSpeechIndex].speaker1
    }

    func allSpeakers() -> [Speaker] {
        refreshCurrentSpeaker()
        return speakers
    }

    func currentSpeech() -> Speech? {
        guard speechTimer.isRunning() else { return nil }

        refreshCurrentSpeaker()
        return speeches[currentSpeechIndex]
    }

    func currentSpeakerIndex() -> Int? {
        guard speechTimer.isRunning() else { return nil }

        refreshCurrentSpeaker()
        return currentSpeechIndex
    }

    func unpauseTimer(forTeam team: Team) {
        if team == .affirmative {
            affirmativeTimer.unpause()
        } else {
            negativeTimer.unpause()
        }
    }

    func pauseTimer(for team: Team) {
        if team == .affirmative {
            affirmativeTimer.pause()
        } else {
            negativeTimer.pause()
        }
    }
}
