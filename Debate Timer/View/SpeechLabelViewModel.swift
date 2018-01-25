//
//  SpeechLabelViewModel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 21.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

struct SpeechLabelViewModel {
    public var speechTime: String? {
        guard let value = speaker.speechTime else { return nil }
        return formatTimeInterval(value)
    }
    public var crossQuestionTime: String? {
        guard let value = speaker.crossQuestionsTime else { return nil }
        return formatTimeInterval(value)
    }
    public var team: Team {
        return speaker.team
    }
    public var name: String {
        return "\(speaker.team.rawValue.uppercased().first!)\(speaker.position)"
    }
    private let speaker: Speaker

    init(speaker: Speaker) {
        self.speaker = speaker
    }

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: interval)!
    }
}

