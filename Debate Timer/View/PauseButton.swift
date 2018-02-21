//
//  PauseButton.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 12.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

protocol PauseButtonDelegate {
    func didTapPauseButton()
}

class PauseButton: UIView {

    // MARK: Public properties

    var delegate: PauseButtonDelegate?
    var team: Team? {
        didSet {
            updateBackgroundColor()
        }
    }
    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                isUserInteractionEnabled = true
            } else {
                isUserInteractionEnabled = false
            }

            updateBackgroundColor()
        }
    }

    // MARK: Private UI properties

    private let playPauseView = PausableView()
    private let teamLabel = CircledLabel()

    // MARK: Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundColor = .clear

        setupConstraints()
        setupGestureRecognizers()
        playPauseView.isPaused = true
    }

    // MARK: Private functions

    private func setupConstraints() {
        addSubview(teamLabel) { l in
            l.edges.pinToSuperview()
        }

        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        teamLabel.addSubview(playPauseView) { v in
            v.edges.pinToSuperviewMargins(insets: insets, relation: .equal)
        }
    }

    private func setupGestureRecognizers() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(gr)
        isUserInteractionEnabled = true
    }

    private func updateBackgroundColor() {
        guard isEnabled else {
            teamLabel.backgroundColor = UIColor(named: "NeutralGray")
            return
        }

        guard let team = team else { return }
        switch team {
        case .affirmative:
            teamLabel.backgroundColor = UIColor(named: "Affirmative")
        case .negative:
            teamLabel.backgroundColor = UIColor(named: "Negative")
        }
    }

    @objc private func didTap() {
        delegate?.didTapPauseButton()
    }

    // MARK: Public functions

    public func togglePaused(to state: Bool? = nil) {
        if let state = state {
            playPauseView.isPaused = state
        } else {
            playPauseView.isPaused = !playPauseView.isPaused!
        }
    }


}
