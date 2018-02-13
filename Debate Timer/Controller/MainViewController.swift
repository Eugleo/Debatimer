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
    private var collectionViewController: SpeakerCardsViewController!

    @IBOutlet var speakerLabels: [SpeechLabel]!
    @IBOutlet weak var teamAffirmativeLabel: TeamTimeLabel!
    @IBOutlet weak var teamNegativeLabel: TeamTimeLabel!
    @IBOutlet weak var pauseView: PauseButton!

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
        pauseView.delegate = self
        pauseView.team = .affirmative
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedCardsCVSegue" {
            let childVC = segue.destination as! SpeakerCardsViewController
            delegate = childVC
            collectionViewController = childVC
            childVC.debate = debate
            childVC.delegate = self
        }
    }

    private var currentLabel: SpeechLabel?
    @objc private func refreshUserInterface() {
        if let index = debate.currentSpeakerIndex() {
            delegate?.refreshCell(atIndex: index)

            let currentSpeaker = debate.currentSpeech()!.speaker1
            currentLabel = speakerLabels.first { $0.viewModel!.speaker == currentSpeaker }
            currentLabel!.activate()

            pauseView.togglePaused(to: true)
        } else {
            teamAffirmativeLabel.timeLeft = debate.teamTimeLeft().affirmative
            teamNegativeLabel.timeLeft = debate.teamTimeLeft().negative

            if let currentTeam = debate.timeRunsForTeam() {
                pauseView.team = currentTeam
                pauseView.togglePaused(to: false)
            }

            if let currentLabel = currentLabel {
                currentLabel.deactivate()
            }
        }
    }
}

extension MainViewController: SpeakerCardDelegate {
    func getTimeLeft() -> TimeInterval {
        return debate.currentSpeechTimeLeft() ?? 0
    }

    func cardTapped(atIndex index: Int) {
        if index < debate.allSpeeches().count {
            if let currentSpeakerIndex = debate.currentSpeakerIndex() {
                if currentSpeakerIndex == index {
                    let currentSpeaker = debate.currentSpeech()!.speaker1
                    currentLabel = speakerLabels.first { $0.viewModel!.speaker == currentSpeaker }
                    currentLabel?.viewModel = SpeechLabelViewModel(speaker: currentSpeaker)
                    debate.stopSpeech()

                    if currentSpeakerIndex < debate.allSpeeches().count - 1 {
                        delegate?.showSpeaker(atIndex: index + 1)
                    }
                } else {
                    delegate?.showSpeaker(atIndex: currentSpeakerIndex)
                }
            } else {
                debate.startSpeech(atIndex: index)
            }
        } else {
            reset()
        }
    }

    private func reset() {
        let alert = UIAlertController(title: "Smazání debaty",
                                      message: "Přejete si opravdu současný průběh debaty smazat a začít debatu novou?",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ano",
                                      style: .destructive,
                                      handler: { _ in self.resetConfirmed()}))
        alert.addAction(UIAlertAction(title: "Zrušit",
                                      style: .cancel,
                                      handler: nil))
        self.show(alert, sender: nil)
    }

    @objc private func resetConfirmed() {
        debate = Debate()
        for (speaker, label) in zip(debate.allSpeakers(), speakerLabels) {
            label.viewModel = SpeechLabelViewModel(speaker: speaker)
            label.delegate = self
        }
        collectionViewController.reset(withNewDebate: debate)
        pauseView.togglePaused(to: false)
    }
}

extension MainViewController: ShadowTappableLabelDelegate {
    func handleTapGesture(sender: ShadowTappableLabel) {
        if let sender = sender as? SpeechLabel {
            let index = debate.allSpeeches().index { $0.speaker1 == sender.viewModel!.speaker && $0.speaker2 == nil}
            delegate?.showSpeaker(atIndex: index!)
        }
    }
}

extension MainViewController: PauseButtonDelegate {
    func tapped() {
        if let currentTeam = debate.timeRunsForTeam() {
            debate.pauseTimer(for: currentTeam)
        } else {
            debate.unpauseTimer(forTeam: pauseView.team!)
        }
        pauseView.togglePaused()
    }
}
