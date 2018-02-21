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
        l.textColor = .darkGray
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 26)
    }

    private let gradientLayer = CAGradientLayer()


    var team: Team? {
        didSet {
            if team != oldValue && team != nil {
                gradientLayer.locations = [0.000001, 0.999999]
                if team == .affirmative {
                    gradientLayer.colors = [UIColor(named: "LightBlue")!.cgColor, UIColor(named: "LightBlue")!.cgColor]
                    gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)

                } else {
                    gradientLayer.colors = [ UIColor(named: "LightRed")!.cgColor, UIColor(named: "LightRed")!.cgColor]
                    gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / -2, 0, 0, 1)
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    private let playPauseView = PausableView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.cornerRadius = 20
        layer.masksToBounds = true

        addSubview(timeLeftLabel) { l in
            l.edges.pinToSuperviewMargins()
        }

        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: interval)!
    }
}
