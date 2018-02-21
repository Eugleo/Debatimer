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
    func refreshCell(atIndex index: Int, withTimeLeft time: TimeInterval)
}

final class MainViewController: UIViewController {

    // MARK: Properties

    var speakers: [SpeakerID: Speaker] = [:]

    var uiTimer: Timer?
    private var debate = Debate()
    private var delegate: SpeakerCardCollectionViewControllerDelegate?
    private var collectionViewController: SpeakerCardsViewController!

    @IBOutlet var speakerLabels: [SpeechLabel]!
    @IBOutlet weak var teamAffirmativeLabel: TeamTimeLabel!
    @IBOutlet weak var teamNegativeLabel: TeamTimeLabel!
    @IBOutlet weak var pauseView: PauseButton!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "CreamWhite")!

        debate.allSpeakers().forEach { speakers[$0] = Speaker(id: $0) }

        let speakerIDs: [SpeakerID] = [.A1, .N1, .A2, .N2, .A3, .N3]
        for label in speakerLabels {
            let speaker = speakerIDs[label.tag]
            label.viewModel = SpeechLabelViewModel(speaker: speakers[speaker]!)
            label.delegate = self
        }

        pauseView.delegate = self
        teamAffirmativeLabel.team = .affirmative
        teamNegativeLabel.team = .negative
        pauseView.team = .affirmative
        pauseView.togglePaused(to: true)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterBackground),
                                               name: .UIApplicationDidEnterBackground, object: nil)
    }

    @objc func appWillEnterForeground(notification: Notification) {
        uiTimer?.invalidate()
        uiTimer = Timer(timeInterval: 0.1, repeats: true) { _ in self.refreshUserInterface() }
        RunLoop.main.add(uiTimer!, forMode: .commonModes)
    }

    @objc func appWillEnterBackground(notification: Notification) {
        uiTimer?.invalidate()
    }

    private var shouldShowOnboard = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard Reviewer.getRunCount() == 1 && shouldShowOnboard else { return }
        showOnboarding()
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
        if let currentSpeechIndex = debate.currentSpeechIndex(),
            let currentTimeLeft = debate.currentSpeechTimeLeft() {

            delegate?.refreshCell(atIndex: currentSpeechIndex, withTimeLeft: currentTimeLeft)
        } else {
            let prepTimeLeft = debate.prepTimeLeft()
            teamAffirmativeLabel.timeLeft = round(prepTimeLeft.affirmative)
            teamNegativeLabel.timeLeft = round(prepTimeLeft.negative)
        }
    }

    private func updatePauseViewTeam() {
        if let currentTeam = debate.teamPreparing() {
            pauseView.team = currentTeam
            pauseView.togglePaused(to: false)
        } else {
            pauseView.togglePaused(to: true)
        }
    }
}

extension MainViewController: SpeechCollectionViewCellDelegate {
    func cardTapped(atIndex index: Int) {
        guard index < debate.allSpeeches().count else {
            askUserBeforeReset()
            Reviewer.showReview()
            return
        }

        if let currentSpeakerID = debate.currentSpeaker(),
           let currentSpeech = debate.currentSpeech(),
           let currentSpeechIndex = debate.currentSpeechIndex() {

            guard currentSpeechIndex == index else {
                delegate?.showSpeaker(atIndex: currentSpeechIndex)
                return
            }

            speakerLabels.forEach { $0.deactivate() }
            let measurement = debate.stopAndMeasureCurrentSpeech()
            updatePauseViewTeam()
            pauseView.isEnabled = true

            let currentSpeaker = speakers[currentSpeakerID]!
            if currentSpeech.isCross {
                currentSpeaker.crossTime = measurement
            } else {
                currentSpeaker.speechTime = measurement
            }

            let currentLabel = speakerLabels.first { $0.viewModel?.speaker.id == currentSpeakerID }!
            currentLabel.viewModel = SpeechLabelViewModel(speaker: currentSpeaker)

            if currentSpeechIndex != debate.allSpeeches().count - 1 {
                delegate?.showSpeaker(atIndex: currentSpeechIndex + 1)
            }
        } else {
            debate.startSpeech(atIndex: index)
            speakerLabels
                .first { $0.viewModel!.speaker.id == debate.currentSpeaker()! }!
                .activate()
            pauseView.isEnabled = false
            updatePauseViewTeam()
        }
    }

    private func askUserBeforeReset() {
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
        debate.allSpeakers().forEach { speakers[$0] = Speaker(id: $0) }
        let speakerIDs: [SpeakerID] = [.A1, .N1, .A2, .N2, .A3, .N3]
        for label in speakerLabels {
            let speaker = speakerIDs[label.tag]
            label.viewModel = SpeechLabelViewModel(speaker: speakers[speaker]!)
            label.delegate = self
        }
        collectionViewController.reset(withNewDebate: debate)
        pauseView.team = .affirmative
        pauseView.togglePaused(to: true)
    }
}

extension MainViewController: ShadowTappableLabelDelegate {
    func handleTapGesture(sender: ShadowTappableLabel) {
        guard let sender = sender as? SpeechLabel else { return }
        let index = debate.allSpeeches().index { $0.speaker1 == sender.viewModel!.speaker.id && $0.speaker2 == nil}
        delegate?.showSpeaker(atIndex: index!)
    }
}

extension MainViewController: PauseButtonDelegate {
    func didTapPauseButton() {
        if let currentTeam = debate.teamPreparing() {
            debate.pauseTimer(for: currentTeam)
        } else {
            debate.unpauseTimer(forTeam: pauseView.team!)
        }
        pauseView.togglePaused()
    }
}

// MARK: Onboarding

extension MainViewController {
    private func showOnboarding() {
        let onboarding = storyboard!.instantiateViewController(withIdentifier: "Onboarding") as! OnboardingViewController

        let o0 = OnboardingCardViewModel(title: "Vítejte",
                                         description: "Vítejte v aplikaci Debatimer, která vám pomůže s měřením času u debat formátu Karl Popper. Následuje krátké seznámení s aplikací.",
                                         kind: .intro)
        let o1 = OnboardingCardViewModel(title: "Měření času",
                                         description: "Zmáčknutím tlačítka ve spodní části obrazovky spustíte stopování následující řeči. Jeho opětovným zmáčknutím měření ukončíte.",
                                         kind: .image,
                                         image: UIImage(named: "O2"))
        let o2 = OnboardingCardViewModel(title: "Naměřené časy",
                                         description: "V horní části obrazovky se postupně ukazují časy řečníků, kteří už mluvili.",
                                         kind: .image,
                                         image: UIImage(named: "O2"))
        let o3 = OnboardingCardViewModel(title: "Přípravné časy",
                                         description: "Uprostřed obrazovky je možno vidět, kolik času k poradě zbývá oběma týmům. Tento čas se měří automaticky, je ale možné jej manuálně pozastavit.",
                                         kind: .image, image: UIImage(named: "O3"))
        let o4 = OnboardingCardViewModel(title: "Nová debata",
                                         description: "Po skončení debaty je možné smazat naměřené časy a začít stopovat znovu stisknutím šedého tlačítka.",
                                         kind: .image,
                                         image: UIImage(named: "O4"))
        let o5 = OnboardingCardViewModel(title: "Konec prohlídky",
                                         description: "Děkujeme, nyní už můžete začít debatovat! Pokud budete mít nějaké dotazy nebo připomínky, napište na wybitul.evzen@gmail.com.",
                                         kind: .ending)

        onboarding.onboardingCards = [o0, o1, o2, o3, o4, o5]

        shouldShowOnboard = false

        present(onboarding, animated: true, completion: nil)
    }
}
