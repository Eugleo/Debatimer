//
//  Debate.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

struct Debate {

    // MARK: - Properties

    private var speeches: [Speech]
    private var affirmativeTimer = CountdownTimer()
    private var negativeTimer = CountdownTimer()
    private var speechTimer = CountdownTimer()

    enum State {
        case speech(Int, SpeakerID), cross(Int, SpeakerID, SpeakerID), preparation(Team), empty
    }

    private(set) var state: State = .empty

    // MARK: - Initialization
    // An implementation with defaults according to classic debate rules: A1, X, N1, X, A2, X, N2, X, A3, N3
    init() {
        let crossTimeLimit: TimeInterval = 180
        let a1 = Speech(speaker1: .A1)
        let n3a1 = Speech(speaker1: .N3, speaker2: .A1, timeLimit: crossTimeLimit)
        let n1 = Speech(speaker1: .N1)
        let a3n1 = Speech(speaker1: .A3, speaker2: .N1, timeLimit: crossTimeLimit)
        let a2 = Speech(speaker1: .A2)
        let n1a2 = Speech(speaker1: .N1, speaker2: .A2, timeLimit: crossTimeLimit)
        let n2 = Speech(speaker1: .N2)
        let a1n2 = Speech(speaker1: .A1, speaker2: .N2, timeLimit: crossTimeLimit)
        let a3 = Speech(speaker1: .A3)
        let n3 = Speech(speaker1: .N3)

        speeches = [a1, n3a1, n1, a3n1, a2, n1a2, n2, a1n2, a3, n3]

        negativeTimer.countdown(startingAt: Team.negative.preparationTime())
        negativeTimer.pause()
        affirmativeTimer.countdown(startingAt: Team.affirmative.preparationTime())
        affirmativeTimer.pause()
    }

    // MARK: - Private functions

    mutating func runPrepTime() {
        switch state {
        case .speech(let i, _) where i == speeches.count - 1,
             .cross(let i, _, _) where i == speeches.count - 1:

            state = .empty
            affirmativeTimer.pause()
            negativeTimer.pause()
            return
        default:
            break
        }

        switch state {
        case .speech(_, let speaker):
            if speaker.team() == .affirmative {
                state = .preparation(.negative)
                negativeTimer.unpause()
            } else {
                state = .preparation(.affirmative)
                affirmativeTimer.unpause()
            }
        case .cross(_, let speaker, _):
            if speaker.team() == .affirmative {
                state = .preparation(.affirmative)
                affirmativeTimer.unpause()
            } else {
                state = .preparation(.negative)
                negativeTimer.unpause()
            }
        default:
            return
        }
    }

    // MARK: - Public functions

    func allSpeeches() -> [Speech] {
        return speeches
    }

    func allSpeakers() -> [SpeakerID] {
        return speeches
            .map { $0.speaker1 }
            .reduce([]) { acc, s in acc.contains(s) ? acc : acc + [s] }
    }

    func currentSpeechTimeLeft() -> TimeInterval? {
        switch state {
        case .speech(_, _), .cross(_, _, _):
            return speechTimer.timeLeft
        default:
            return nil
        }
    }

    mutating func startSpeech(atIndex index: Int) {
        guard index < speeches.count else { return }

        affirmativeTimer.pause()
        negativeTimer.pause()

        let currentSpeech = speeches[index]
        speechTimer.countdown(startingAt: currentSpeech.timeLimit)

        if !currentSpeech.isCross {
            state = .speech(index, currentSpeech.speaker1)
        } else {
            state = .cross(index, currentSpeech.speaker1, currentSpeech.speaker2!)
        }
    }

    mutating func stopAndMeasureCurrentSpeech() -> TimeInterval {
        runPrepTime()

        let measurement = speechTimer.elapsedTime
        speechTimer.stop()
        return measurement
    }

    func prepTimeLeft() -> (affirmative: TimeInterval, negative: TimeInterval) {
        return (affirmative: affirmativeTimer.timeLeft, negativeTimer.timeLeft)
    }

    func isTeamTimerRunning() -> Bool {
        return affirmativeTimer.isRunning() || negativeTimer.isRunning()
    }

    mutating func unpauseTeamTimer() {
        guard case let .preparation(team) = state else { return }

        if team == .affirmative {
            affirmativeTimer.unpause()
            negativeTimer.pause()
        } else {
            negativeTimer.unpause()
            affirmativeTimer.pause()
        }
    }

    mutating func pauseTeamTimer() {
        guard case let .preparation(team) = state else { return }
        
        if team == .affirmative {
            affirmativeTimer.pause()
        } else {
            negativeTimer.pause()
        }
    }
}
