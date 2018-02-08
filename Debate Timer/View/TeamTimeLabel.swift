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

    public func togglePaused(to state: Bool? = nil) {
        if let state = state {
            playPauseView.isPaused = state
        } else {
            playPauseView.isPaused = !playPauseView.isPaused!
        }
    }

    var team: Team? {
        didSet {
            guard let team = team else { return }

            if team == .affirmative {
                teamLabel.backgroundColor = UIColor(named: "Affirmative")
            } else {
                teamLabel.backgroundColor = UIColor(named: "Negative")
            }
        }
    }

    private let timeLeftLabel = UILabel { l in
        l.textColor = .lightGray
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 26)
    }

    private let teamLabel = CircledLabel()
    private let playPauseView = PlayPauseView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundColor = UIColor(named: "CreamWhite")

        addSubview(teamLabel) { l in
            l.leading.pinToSuperviewMargin(inset: 5, relation: .equal)
            l.top.pinToSuperviewMargin()
            l.bottom.pinToSuperviewMargin()
            l.height.match(l.width)
            l.height.set(30)
        }

        teamLabel.addSubview(playPauseView) { v in
            v.edges.pinToSuperviewMargins()
        }

        addSubview(timeLeftLabel) { l in
            l.top.pinToSuperviewMargin()
            l.bottom.pinToSuperviewMargin()
            l.trailing.pinToSuperviewMargin()
            l.leading.align(with: teamLabel.al.trailing)
        }

        playPauseView.isPaused = true
    }

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: interval)!
    }
}
