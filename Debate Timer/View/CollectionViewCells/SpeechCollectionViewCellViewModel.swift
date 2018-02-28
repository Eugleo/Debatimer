//
//  SpeakerCardCellViewModel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 21.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation
import UIKit

struct SpeechCollectionViewCellViewModel {

    // MARK: - Public properties

    public var timeLimit: String {
        return Format.formatTimeInterval(speech.timeLimit)
    }

    public var team: Team {
        return speech.speaker1.team()
    }

    public var speaker1Name: String {
        return speech.speaker1.rawValue
    }

    public var speaker2Name: String? {
        guard let speaker2 = speech.speaker2 else { return nil }
        return speaker2.rawValue
    }

    public var backgroundGradient: [UIColor] {
        return team == .affirmative ?
            Constants.UI.GradientColors.affirmative :
            Constants.UI.GradientColors.negative
    }

    // MARK: - Private properties

    private let speech: Speech

    // MARK: - Initialization

    init(speech: Speech) {
        self.speech = speech
    }
}
