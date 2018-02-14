//
//  MainViewController.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import SwiftyOnboardVC

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

        uiTimer = Timer(timeInterval: 0.1, repeats: true, block: { _ in
            self.refreshUserInterface()
        })

        RunLoop.main.add(uiTimer, forMode: .commonModes)

        for (speaker, label) in zip(debate.allSpeakers(), speakerLabels) {
            label.viewModel = SpeechLabelViewModel(speaker: speaker)
            label.delegate = self
        }
        pauseView.delegate = self
        teamAffirmativeLabel.team = .affirmative
        teamNegativeLabel.team = .negative
        pauseView.team = .affirmative
        pauseView.togglePaused(to: true)
    }

    private var onboard: SwiftyOnboardVC!
    var i = 0

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let viewOne = storyboard!.instantiateViewController(withIdentifier: "OnboardingOne")
        let viewTwo = storyboard!.instantiateViewController(withIdentifier: "OnboardingTwo")
        let viewThree = storyboard!.instantiateViewController(withIdentifier: "OnboardingThree")
        let viewFour = storyboard!.instantiateViewController(withIdentifier: "OnboardingFour")
        let viewFive = storyboard!.instantiateViewController(withIdentifier: "OnboardingFive")
        let viewControllers = [viewOne, viewTwo, viewThree, viewFour, viewFive]

        onboard = SwiftyOnboardVC(viewControllers: viewControllers)
        onboard.backgroundColor = UIColor(named: "Affirmative")!

        onboard.showLeftButton = false
        onboard.rightButtonText = "Přeskočit prohlídku"
        onboard.rightButtonBackgroundColor = .clear
        onboard.rightButtonTextColor = .darkText
        onboard.currentPageControlTintColor = UIColor(named: "Affirmative")!

        onboard.delegate = self

        //let shouldNotShowOnboard = UserDefaults.standard.bool(forKey: "shouldNotShowOnboard2")
        if i == 0 {
            present(onboard, animated: true, completion: nil)
            i = 1
            //UserDefaults.standard.set(true, forKey: "shouldNotShowOnboard2")
        }
        //UserDefaults.standard.set(false, forKey: "shouldNotShowOnboard")
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



            if let index = self.debate.currentSpeakerIndex() {
                let currentSpeaker = self.debate.currentSpeech()!.speaker1

                    self.delegate?.refreshCell(atIndex: index)
                    self.currentLabel = self.speakerLabels.first { $0.viewModel!.speaker == currentSpeaker }
                    self.currentLabel!.activate()
                    self.pauseView.togglePaused(to: true)

            } else {

                    self.teamAffirmativeLabel.timeLeft = self.debate.teamTimeLeft().affirmative
                    self.teamNegativeLabel.timeLeft = self.debate.teamTimeLeft().negative

                    if let currentTeam = self.debate.timeRunsForTeam() {
                        self.pauseView.team = currentTeam
                        self.pauseView.togglePaused(to: false)
                    }

                    if let currentLabel = self.currentLabel {
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
        pauseView.team = .affirmative
        pauseView.togglePaused(to: true)
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

extension MainViewController: SwiftyOnboardVCDelegate {
    func rightButtonPressed() {
        onboard.skip()
        dismiss(animated: true, completion: nil)
    }
}
