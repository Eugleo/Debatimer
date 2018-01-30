//
//  TeamTimeLabel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 25.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

protocol TeamTimeLabelDelegate {
    func tapped(sender: TeamTimeLabel)
}

final class TeamTimeLabel: UIView {
    var delegate: TeamTimeLabelDelegate?

    var timeLeft: TimeInterval? {
        didSet {
            guard let timeLeft = timeLeft else { return }

            timeLeftLabel.text = formatTimeInterval(timeLeft)
        }
    }

    var team: Team? {
        didSet {
            guard let team = team else { return }

            if team == .affirmative {
                teamLabel.text = "A"
                teamLabel.backgroundColor = UIColor(named: "Affirmative")
            } else {
                teamLabel.text = "N"
                teamLabel.backgroundColor = UIColor(named: "Negative")
            }
        }
    }

    private let timeLeftLabel = UILabel {
        $0.textColor = .lightGray
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 26)
    }

    private let teamLabel = CircledLabel()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.03
        layer.cornerRadius = 15

        addSubview(teamLabel) { l in
            l.leading.pinToSuperviewMargin()
            l.top.pinToSuperviewMargin()
            l.bottom.pinToSuperviewMargin()
            l.height.match(l.width)
            l.height.set(30)
        }

        addSubview(timeLeftLabel) { l in
            l.top.pinToSuperviewMargin()
            l.bottom.pinToSuperviewMargin()
            l.trailing.pinToSuperviewMargin()
            l.leading.align(with: teamLabel.al.trailing.offsetting(by: 7))
        }

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    @objc private func tapped() {
        delegate?.tapped(sender: self)
    }

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: interval)!
    }
}
