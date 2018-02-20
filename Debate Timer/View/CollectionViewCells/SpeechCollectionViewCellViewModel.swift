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
    // MARK: Public properties
    public var timeLeftStr: String? {
        return formatTimeInterval(timeLeft ?? speech.timeLimit)
    }
    private var timeLeft: TimeInterval?
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
    public var backgroundColor: UIColor {
        return team == .affirmative ?
            UIColor(named: "Affirmative")! :
            UIColor(named: "Negative")!
    }

    // MARK: Initialization
    private let speech: Speech3

    // MARK: Private properties
    init(speech: Speech3, timeLeft: TimeInterval? = nil) {
        self.speech = speech
        self.timeLeft = timeLeft
    }

    // MARK: Private functions
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: interval)!
    }
}
