//
//  SpeakerCardCellViewModel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 21.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

struct SpeakerCardCellViewModel {
    public var timeLeft: String? {
        let elapsedTime =
            speech.isCrossQuestion ?
                (speech.speaker1.crossQuestionsTime ?? 0) :
                (speech.speaker1.speechTime ?? 0)

        return formatTimeInterval(speech.timeLimit - elapsedTime)
    }
    public var team: Team {
        return speech.speaker1.team
    }
    public var speaker1name: String {
        return "\(speech.speaker1.team.rawValue.uppercased().first!)\(speech.speaker1.position)"
    }
    public var speaker2Name: String? {
        guard let speaker2 = speech.speaker2 else { return nil }
        return "\(speaker2.team.rawValue.uppercased().first!)\(speaker2.position)"
    }
    private let speech: Speech

    init(speech: Speech) {
        self.speech = speech
    }

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: interval)!
    }
}
