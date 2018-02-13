//
//  TeamTimeLabel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 25.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

final class TeamTimeLabel: ShadowTappableLabel {
    var timeLeft: TimeInterval? {
        didSet {
            guard let timeLeft = timeLeft else { return }

            timeLeftLabel.text = formatTimeInterval(timeLeft)
        }
    }

    private let timeLeftLabel = UILabel { l in
        l.textColor = .lightGray
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 26)
    }
    
    private let playPauseView = PlayPauseView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundColor = .clear

        addSubview(timeLeftLabel) { l in
            l.edges.pinToSuperviewMargins()
        }
    }

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: interval)!
    }
}
