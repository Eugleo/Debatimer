//
//  SpeechLabelViewModel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 21.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

struct SpeakerLabelViewModel {

    // MARK: - Public properties

    var speechTimeColor: UIColor {
        guard let speechTime = speaker.speechTime else { return .darkGray }
        return speechTime > speaker.id.timeLimit() ? Constants.UI.Colors.errorDarkRed : .darkGray
    }

    var crossTimeColor: UIColor {
        guard let crossTime = speaker.crossTime else { return .lightGray }
        return crossTime > Constants.crossQuestionTime ? Constants.UI.Colors.errorLightRed : .lightGray
    }

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

    // MARK: - Initialization

    init(speaker: Speaker) {
        self.speaker = speaker
    }

    // MARK: - Private functions

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: interval)!
    }
}

