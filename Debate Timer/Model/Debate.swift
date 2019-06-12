//
//  Debate.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

enum SpeechType {
    case questions(asking: SpeakerID, answering: SpeakerID), normal(speaking: SpeakerID)
    
    func timeLimit() -> TimeInterval {
        switch self {
        case .normal(speaking: let speaker):
            return speaker.timeLimit()
        case .questions(asking: _, answering: _):
            return Constants.crossQuestionTime
        }
    }
}

enum Action {
    case speech(type: SpeechType), preparation(team: Team)
    
    func timeLimit() -> TimeInterval {
        switch self {
        case .preparation(let team):
            return team.preparationTime()
        case .speech(type: let speechType):
            return speechType.timeLimit()
        }
    }
}

class NewDebate {
    var actions: [Action]
    var speeches: [NewSpeech] = []
    var stopwatch = Stopwatch()
    
    var affirmativeTeamTimeLeft = Team.affirmative.preparationTime()
    var negativeTeamTimeLeft = Team.negative.preparationTime()
    
    var currentAction: Action?
    
    init() {
        actions = [
            .speech(type: .normal(speaking: .A1)),
            .preparation(team: .negative),
            .speech(type: .questions(asking: .N3, answering: .A1)),
            .preparation(team: .negative),
            .speech(type: .normal(speaking: .N1)),
            .preparation(team: .affirmative),
            .speech(type: .questions(asking: .A3, answering: .N1)),
            .preparation(team: .affirmative),
            .speech(type: .normal(speaking: .A2)),
            .preparation(team: .negative),
            .speech(type: .questions(asking: .N1, answering: .A2)),
            .preparation(team: .negative),
            .speech(type: .normal(speaking: .N2)),
            .preparation(team: .affirmative),
            .speech(type: .questions(asking: .A1, answering: .N2)),
            .preparation(team: .affirmative),
            .speech(type: .normal(speaking: .A3)),
            .preparation(team: .negative),
            .speech(type: .normal(speaking: .N3)),
        ]
    }
    
    func startAction(atIndex index: Int) {
        guard index < actions.count else {
            fatalError("Wrong index passed to function startAction(atIndex:).")
        }
        
        currentAction = actions[index]
        stopwatch.startNewInterval()
    }
    
    func stopCurrentAction() {
        guard let currentAction = currentAction else {
            print("Error: No action to stop")
            return
        }
        
        let time = stopwatch.currentIntervalLength()!
        
        switch currentAction {
        case .preparation(team: let team):
            switch team {
            case .affirmative:
                affirmativeTeamTimeLeft -= time
            case .negative:
                negativeTeamTimeLeft -= time
            }
        case .speech(type: let type):
            switch type {
            case .normal(speaking: let speaker):
                speeches.append(NewSpeech(speaker: speaker, length: time))
            case .questions(asking: let speaker1, answering: let speaker2):
                speeches.append(NewSpeech(speaker1: speaker1, speaker2: speaker2, length: time))
            }
        }
    }
    
    func actionTimeLeft() -> TimeInterval {
        guard let currentAction = currentAction else {
            fatalError("Debate isn't running, there's no time left of anything.")
        }
        
        return currentAction.timeLimit() - (stopwatch.currentIntervalLength() ?? 0)
    }
    
    func timeLeft(ofTeam team: Team) -> TimeInterval {
        switch team {
        case .affirmative:
            return affirmativeTeamTimeLeft
        case .negative:
            return negativeTeamTimeLeft
        }
    }
    
    func allActions() -> [Action] {
        return actions
    }
}

class NewSpeech {
    var length: TimeInterval
    let type: SpeechType
    var timeLimit: TimeInterval {
        get {
            switch self.type {
            case .questions(_):
                return Constants.crossQuestionTime
            case .normal(let speaker):
                return speaker.timeLimit()
            }
        }
    }
    
    init(speaker: SpeakerID, length: TimeInterval) {
        self.type = .normal(speaking: speaker)
        self.length = length
    }
    
    init(speaker1: SpeakerID, speaker2: SpeakerID, length: TimeInterval) {
        self.type = .questions(asking: speaker1, answering: speaker2)
        self.length = length
    }
}

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
        let a1 = Speech(speaker1: .A1)
        let n3a1 = Speech(speaker1: .N3, speaker2: .A1, timeLimit: Constants.crossQuestionTime)
        let n1 = Speech(speaker1: .N1)
        let a3n1 = Speech(speaker1: .A3, speaker2: .N1, timeLimit: Constants.crossQuestionTime)
        let a2 = Speech(speaker1: .A2)
        let n1a2 = Speech(speaker1: .N1, speaker2: .A2, timeLimit: Constants.crossQuestionTime)
        let n2 = Speech(speaker1: .N2)
        let a1n2 = Speech(speaker1: .A1, speaker2: .N2, timeLimit: Constants.crossQuestionTime)
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
