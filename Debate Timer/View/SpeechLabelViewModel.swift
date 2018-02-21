//
//  SpeechLabelViewModel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 21.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation

struct SpeechLabelViewModel {

    // MARK: Public properties

    var speechTime: String? {
        guard let ti = speaker.speechTime else { return nil }
        return formatTimeInterval(ceil(ti))
    }

    var crossQuestionTime: String? {
        guard let ti = speaker.crossTime else { return nil }
        return formatTimeInterval(ceil(ti))
    }

    var name: String {
        return speaker.id.rawValue
    }

    var team: Team {
        return speaker.id.team()
    }

    let speaker: Speaker

    // MARK: Initialization

    init(speaker: Speaker) {
        self.speaker = speaker
    }

    // MARK: Private functions

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: interval)!
    }
}

