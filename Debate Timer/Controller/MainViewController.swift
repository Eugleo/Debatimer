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
    var uiTimer: Timer?
    private var debate = Debate()
    private var delegate: SpeakerCardCollectionViewControllerDelegate?
    private var collectionViewController: SpeakerCardsViewController!

    @IBOutlet var speakerLabels: [SpeechLabel]!
    @IBOutlet weak var teamAffirmativeLabel: TeamTimeLabel!
    @IBOutlet weak var teamNegativeLabel: TeamTimeLabel!
    @IBOutlet weak var pauseView: PauseButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "CreamWhite")!

        for (speaker, label) in zip(debate.allSpeakers(), speakerLabels) {
            label.viewModel = SpeechLabelViewModel(speaker: speaker)
            label.delegate = self
        }
        pauseView.delegate = self
        teamAffirmativeLabel.team = .affirmative
        teamNegativeLabel.team = .negative
        pauseView.team = .affirmative
        pauseView.togglePaused(to: true)

        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: .UIApplicationDidBecomeActive, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
    }

    @objc func appWillEnterForeground(notification: Notification) {
        uiTimer?.invalidate()
        uiTimer = Timer(timeInterval: 0.1, repeats: true, block: { _ in
            self.refreshUserInterface()
        })
        RunLoop.main.add(uiTimer!, forMode: .commonModes)
    }

    @objc func appWillEnterBackground(notification: Notification) {
        uiTimer?.invalidate()
    }

    private var shouldShowOnboard = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard Reviewer.getRunCount() == 1 && shouldShowOnboard else { return }

        let onboarding = storyboard!.instantiateViewController(withIdentifier: "Onboarding") as! OnboardingViewController
        let o0 = OnboardingCard(title: "Vítejte", description: "Vítejte v aplikaci Debatimer, která vám pomůže s měřením času u debat formátu Karl Popper. Následuje krátké seznámení s aplikací.", kind: .intro)
        let o1 = OnboardingCard(title: "Měření času", description: "Zmáčknutím tlačítka ve spodní části obrazovky spustíte stopování následující řeči. Jeho opětovným zmáčknutím měření ukončíte.", kind: .image, image: UIImage(named: "O2"))
        let o2 = OnboardingCard(title: "Naměřené časy", description: "V horní části obrazovky se postupně ukazují časy řečníků, kteří už mluvili.", kind: .image, image: UIImage(named: "O2"))
        let o3 = OnboardingCard(title: "Přípravné časy", description: "Uprostřed obrazovky je možno vidět, kolik času k poradě zbývá oběma týmům. Tento čas se měří automaticky, je ale možné jej manuálně pozastavit.", kind: .image, image: UIImage(named: "O3"))
        let o4 = OnboardingCard(title: "Nová debata", description: "Po skončení debaty je možné smazat naměřené časy a začít stopovat znovu stisknutím šedého tlačítka.", kind: .image, image: UIImage(named: "O4"))
        let o5 = OnboardingCard(title: "Konec prohlídky", description: "Děkujeme, nyní už můžete začít debatovat! Pokud budete mít nějaké dotazy nebo připomínky, napište na wybitul.evzen@gmail.com.", kind: .ending)

        onboarding.onboardingCards = [o0, o1, o2, o3, o4, o5]

        shouldShowOnboard = false
        
        present(onboarding, animated: true, completion: nil)
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

    @objc private func refreshUserInterface() {
        if let index = debate.currentSpeakerIndex() {
            let currentSpeaker = debate.currentSpeech()!.speaker1

                delegate?.refreshCell(atIndex: index)
                let currentLabel = speakerLabels.first { $0.viewModel!.speaker == currentSpeaker }
                currentLabel!.activate()
                pauseView.togglePaused(to: true)

        } else {
                teamAffirmativeLabel.timeLeft = debate.teamTimeLeft().affirmative
                teamNegativeLabel.timeLeft = debate.teamTimeLeft().negative

                if let currentTeam = debate.timeRunsForTeam() {
                    pauseView.team = currentTeam
                    pauseView.togglePaused(to: false)
                }

                speakerLabels.forEach { $0.deactivate() }
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
                    let currentLabel = speakerLabels.first { $0.viewModel!.speaker == currentSpeaker }
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
            Reviewer.showReview()
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
