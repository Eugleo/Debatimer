//
//  MainViewController.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

protocol SpeakerCardCollectionViewControllerDelegate {
    func showSpeaker(atIndex index: Int)
    func refreshCell(atIndex index: Int)
}

final class MainViewController: UIViewController {
    private var debate = Debate()
    private var uiTimer: Timer!
    private var delegate: SpeakerCardCollectionViewControllerDelegate?

    @IBOutlet var speakerLabels: [SpeechLabel]!
    @IBOutlet weak var teamAffirmativeLabel: TeamTimeLabel!
    @IBOutlet weak var teamNegativeLabel: TeamTimeLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "CreamWhite")!
        uiTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                       target: self,
                                       selector: #selector(refreshUserInterface),
                                       userInfo: nil,
                                       repeats: true)
        for (speaker, label) in zip(debate.allSpeakers(), speakerLabels) {
            label.viewModel = SpeechLabelViewModel(speaker: speaker)
            label.delegate = self
        }
        teamNegativeLabel.team = .negative
        teamNegativeLabel.delegate = self
        teamAffirmativeLabel.team = .affirmative
        teamAffirmativeLabel.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedCardsCVSegue" {
            let childVC = segue.destination as! SpeakerCardsViewController
            delegate = childVC
            childVC.debate = debate
            childVC.delegate = self
        }
    }

    @objc private func refreshUserInterface() {
        if let index = debate.currentSpeakerIndex() {
            delegate?.refreshCell(atIndex: index)
        } else {
            teamAffirmativeLabel.timeLeft = debate.teamTimeLeft().affirmative
            teamNegativeLabel.timeLeft = debate.teamTimeLeft().negative
        }
    }
}

extension MainViewController: SpeakerCardDelegate {
    func getTimeLeft() -> TimeInterval {
        return debate.currentSpeechTimeLeft() ?? 0
    }

    func cardTapped(atIndex index: Int) {
        if debate.currentSpeaker() != nil {
            for (speaker, label) in zip(debate.allSpeakers(), speakerLabels) {
                label.viewModel = SpeechLabelViewModel(speaker: speaker)
            }
            debate.stopSpeech()
            delegate?.showSpeaker(atIndex: index + 1)
        } else {
            debate.startSpeech(atIndex: index)
        }
    }
}

extension MainViewController: SpeechLabelDelegate {
    func tapped(sender: SpeechLabel) {
        let index = debate.allSpeeches().index { $0.speaker1 == sender.viewModel!.speaker && $0.speaker2 == nil}
        delegate?.showSpeaker(atIndex: index!)
    }
}

extension MainViewController: TeamTimeLabelDelegate {
    func tapped(sender: TeamTimeLabel) {
        guard let team = sender.team else { return }

        if let currentTeam = debate.timeRunsForTeam() {
            if team == currentTeam {
                debate.pauseTimer(for: team)
            }
        } else {
            debate.unpauseTimer(forTeam: team)
        }
    }
}
