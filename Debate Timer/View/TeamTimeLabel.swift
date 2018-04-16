//
//  TeamTimeLabel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 25.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

final class TeamTimeLabel: ShadowTappableLabel {

    // MARK: - Public properties

    var font: UIFont = UIFont.boldSystemFont(ofSize: 22) {
        didSet {
            timeLeftLabel.font = font
        }
    }

    var timeLeft: TimeInterval? {
        didSet {
            guard let timeLeft = timeLeft, round(timeLeft) >= 0 else { return }
            timeLeftLabel.text = formatTimeInterval(round(timeLeft))
        }
    }

    // MARK: - Private UI properties

    private let timeLeftLabel = UILabel().with { l in
        l.textColor = .darkGray
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 22)
    }

    // MARK: - Initialization

    override init() {
        super.init()
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.height / 2
    }

    // MARK: - Private functions

    private func setupViews() {
        layer.cornerRadius = Constants.UI.CornerRadius.standart
        layer.masksToBounds = true

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
