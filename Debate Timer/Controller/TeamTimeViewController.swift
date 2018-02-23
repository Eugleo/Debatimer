//
//  TeamTimeViewController.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 23.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class TeamTimeViewController: UIViewController {

     // MARK: Private UI properties

    private let stackView = UIStackView().with { v in
        v.alignment = .fill
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.spacing = 0
    }

    private let affirmativeTimeLabel = TeamTimeLabel().with { l in
        l.backgroundColor = Constants.UI.Colors.affirmativeLight
    }

    private let negativeTimeLabel = TeamTimeLabel().with { l in
        l.backgroundColor = Constants.UI.Colors.negativeLight
    }

    private let pauseButton = PauseButton().with { b in
        b.togglePaused(to: true)
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: Private functions

    private func setupViews() {
        // Main stack view
        view.addSubview(stackView) { v in
            v.edges.pinToSuperview()
        }
        stackView.insertArrangedSubviews([affirmativeTimeLabel, negativeTimeLabel])

        // Aff. and neg. "fixes", they cover up the round corners in the middle
        let affirmativeFixerView = UIView().with { v in
            v.backgroundColor = affirmativeTimeLabel.backgroundColor
        }
        let negativeFixerView = UIView().with { v in
            v.backgroundColor = negativeTimeLabel.backgroundColor
        }

        view.addSubview(affirmativeFixerView, negativeFixerView) { av, nv in
            av.trailing.align(with: affirmativeTimeLabel.al.trailing)
            av.top.align(with: affirmativeTimeLabel.al.top)
            av.bottom.align(with: affirmativeTimeLabel.al.bottom)
            av.width.set(30)

            nv.leading.align(with: negativeTimeLabel.al.leading)
            nv.top.align(with: negativeTimeLabel.al.top)
            nv.bottom.align(with: negativeTimeLabel.al.bottom)
            nv.width.set(30)
        }

        // Pause button
        view.addSubview(pauseButton) { b in
            b.height.match(b.width)
            b.height.set(40)
            b.top.align(with: stackView.al.top)
            b.bottom.align(with: stackView.al.bottom)
            b.centerX.align(with: affirmativeTimeLabel.al.trailing)
        }

        if let parent = parent as? PauseButtonDelegate {
            pauseButton.delegate = parent
        }
    }

    // MARK: Public functions

    func setTimeLeft(_ time: TimeInterval, forTeam team: Team) {
        switch team {
        case .affirmative:
            affirmativeTimeLabel.timeLeft = time
        case .negative:
            negativeTimeLabel.timeLeft = time
        }
    }

    func setCurrentTeam(to team: Team) {
        pauseButton.bckgrndColor = team == .affirmative ?
            Constants.UI.Colors.affirmative :
            Constants.UI.Colors.negative
    }

    func setEnabled(to state: Bool) {
        pauseButton.isEnabled = state
    }

    func togglePaused(to state: Bool? = nil) {
        pauseButton.togglePaused(to: state)
    }
}
