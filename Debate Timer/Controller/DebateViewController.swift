//
//  TestViewController.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 23.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import Yalta
import DeviceKit

protocol SpeakerCardCollectionViewControllerDelegate {
    func showSpeaker(atIndex index: Int)
}

class DebateViewController: UIViewController {

    // MARK: - Private properties

    private var uiTimer: Timer?
    private var speakers: [SpeakerID: Speaker] = [:]
    private var debate = Debate()
    private var shouldShowOnboard = true

    private let speakerLabelsVC: SpeakerLabelsViewController
    private let teamTimeVC: TeamTimeViewController
    private let speechesCollectionVC: SpeechesCollectionViewController

    // MARK: - Private UI properties

    private let superStackView = UIStackView().with { v in
        v.alignment = .center
        v.axis = .vertical
        v.distribution = .fill
        v.spacing = Constants.UI.Spacing.medium
    }

    // MARK: - Initialization

    init() {
        for speakerID in debate.allSpeakers() {
            speakers[speakerID] = Speaker(id: speakerID)
        }

        let speakerIDs: [SpeakerID] = [.A1, .A2, .A3, .N1, .N2, .N3]
        var spVms: [SpeakerLabelViewModel] = []
        for sp in speakerIDs {
            spVms.append(SpeakerLabelViewModel(speaker: speakers[sp]!))
        }

        speakerLabelsVC = SpeakerLabelsViewController(vm1: spVms[0],
                                                      vm2: spVms[1],
                                                      vm3: spVms[2],
                                                      vm4: spVms[3],
                                                      vm5: spVms[4],
                                                      vm6: spVms[5])

        teamTimeVC = TeamTimeViewController()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = Constants.UI.Spacing.large
        speechesCollectionVC = SpeechesCollectionViewController(collectionViewLayout: layout,
                                                          speeches: debate.allSpeeches())

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLifecycleNotificaitions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if shouldShowOnboard && Reviewer.getRunCount() < 1 {
            showOnboarding()
        }
    }

    @objc private func appWillEnterForeground(notification: Notification) {
        uiTimer?.invalidate()
        uiTimer = Timer(timeInterval: 0.1, repeats: true) { _ in self.refreshUserInterface() }
        RunLoop.main.add(uiTimer!, forMode: .commonModes)
    }

    @objc private func appWillEnterBackground(notification: Notification) {
        uiTimer?.invalidate()
    }

    // MARK: - Private functions

    private func setupLifecycleNotificaitions() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterBackground),
                                               name: .UIApplicationDidEnterBackground, object: nil)
    }

    private func setupViews() {
        speechesCollectionVC.delegate = self
        view.backgroundColor = Constants.UI.Colors.almostWhite

        view.addSubview(superStackView) { v in
            let insets = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
            v.edges.pinToSafeArea(of: self, insets: insets, relation: .equal)
        }

        let prepTimeLeft = debate.prepTimeLeft()
        teamTimeVC.setTimeLeft(prepTimeLeft.negative, forTeam: .negative)
        teamTimeVC.setTimeLeft(prepTimeLeft.affirmative, forTeam: .affirmative)

        addViewControllerToStackView(speakerLabelsVC, atIndex: 0, widthOffset: -Constants.UI.Spacing.large * 2)
        addViewControllerToStackView(teamTimeVC, atIndex: 1, widthOffset: -Constants.UI.Spacing.large * 2)
        addViewControllerToStackView(speechesCollectionVC, atIndex: 2, widthOffset: 0)

        guard Device().isPad else { return }

        Constraints(for: speechesCollectionVC.view) { v in
            v.height.set(view.frame.height / 2.5, relation: .lessThanOrEqual)
        }
    }

    private func addViewControllerToStackView(_ vc: UIViewController, atIndex index: Int, widthOffset offset: CGFloat) {
        addChildViewController(vc)
        superStackView.insertArrangedSubview(vc.view, at: index)
        vc.didMove(toParentViewController: self)
        Constraints(for: vc.view) { v in
            v.width.match(superStackView.al.width, offset: offset, multiplier: 1, relation: .equal)
        }
    }

    @objc private func refreshUserInterface() {
        switch debate.state {
        case .speech(let i, _), .cross(let i, _, _):
            let currentTimeLeft = debate.currentSpeechTimeLeft()!
            speechesCollectionVC.refreshCell(atIndex: i, withTimeLeft: currentTimeLeft)
        case .empty:
            teamTimeVC.setEnabled(to: false)
        case .preparation(let team):
            let prepTimeLeft = debate.prepTimeLeft()
            teamTimeVC.setEnabled(to: true)

            if team == .affirmative {
                 teamTimeVC.setTimeLeft(prepTimeLeft.affirmative, forTeam: .affirmative)
            } else {
                 teamTimeVC.setTimeLeft(prepTimeLeft.negative, forTeam: .negative)
            }
        }
    }

    private func updatePauseViewTeam() {
        switch debate.state {
        case .preparation(let team):
            teamTimeVC.setCurrentTeam(to: team)
            teamTimeVC.togglePaused(to: false)
        default:
            teamTimeVC.togglePaused(to: true)
        }
    }
}

// MARK: - Speech collection view cell delegate implementation

extension DebateViewController: SpeechCollectionViewCellDelegate {
    func cardTapped(at index: Int) {
        guard index < debate.allSpeeches().count else {
            askUserBeforeReset()
            Reviewer.showReview()
            return
        }

        let state = debate.state
        switch state {
        case .speech(let i, let speaker), .cross(let i, let speaker, _):
            guard i == index else {
                speechesCollectionVC.showSpeaker(atIndex: i)
                return
            }

            let currentSpeaker = speakers[speaker]!
            let measurement = debate.stopAndMeasureCurrentSpeech()

            if case .speech(_, _) = state {
                currentSpeaker.speechTime = measurement
            } else {
                currentSpeaker.crossTime = measurement
            }

            speakerLabelsVC.setActivated(ofLabelWithSpeaker: speaker, to: false)
            speakerLabelsVC.setViewModel(ofLabelWithSpeaker: speaker, to: SpeakerLabelViewModel(speaker: currentSpeaker))

            updatePauseViewTeam()

            if i != debate.allSpeeches().count - 1 {
                speechesCollectionVC.showSpeaker(atIndex: i + 1)
            }
        default:
            debate.startSpeech(atIndex: index)

            switch debate.state {
            case .speech(_, let speaker), .cross(_, let speaker, _):
                speakerLabelsVC.setActivated(ofLabelWithSpeaker: speaker, to: true)
                teamTimeVC.setEnabled(to: false)
                updatePauseViewTeam()
            default:
                return
            }
        }
    }

    private func askUserBeforeReset() {
        let alert = UIAlertController(title: "Smazání debaty",
                                      message: "Přejete si opravdu současný průběh debaty smazat a začít debatu novou?",
                                      preferredStyle: Device().isPhone ? .actionSheet : .alert)
        alert.addAction(UIAlertAction(title: "Ano",
                                      style: .destructive,
                                      handler: { _ in self.reset()}))
        alert.addAction(UIAlertAction(title: "Zrušit",
                                      style: .cancel,
                                      handler: nil))
        self.show(alert, sender: nil)
    }

    @objc private func reset() {
        debate = Debate()
        debate.allSpeakers().forEach { speakers[$0] = Speaker(id: $0) }

        let spVms = [SpeakerID.A1, .A2, .A3, .N1, .N2, .N3].map { SpeakerLabelViewModel(speaker: speakers[$0]!) }
        speakerLabelsVC.reset(vm1: spVms[0],
                              vm2: spVms[1],
                              vm3: spVms[2],
                              vm4: spVms[3],
                              vm5: spVms[4],
                              vm6: spVms[5])
        speechesCollectionVC.reset(withSpeeches: debate.allSpeeches())

        let prepTimeLeft = debate.prepTimeLeft()
        teamTimeVC.setTimeLeft(prepTimeLeft.affirmative, forTeam: .affirmative)
        teamTimeVC.setTimeLeft(prepTimeLeft.negative, forTeam: .negative)

        teamTimeVC.togglePaused(to: true)
    }
}

// MARK: - Shadow tappable label button delegate implementation

extension DebateViewController: ShadowTappableLabelDelegate {
    func handleTapGesture(sender: ShadowTappableLabel) {
        guard let sender = sender as? SpeakerLabel else { return }
        let index = debate.allSpeeches().index { $0.speaker1 == sender.viewModel!.speaker.id && $0.speaker2 == nil }
        speechesCollectionVC.showSpeaker(atIndex: index!)
    }
}

// MARK: - Pause button delegate implementation

extension DebateViewController: PauseButtonDelegate {
    func pauseButtonTapped(sender: PauseButton) {
        if debate.isTeamTimerRunning() {
            debate.pauseTeamTimer()
        } else {
            debate.unpauseTeamTimer()
        }
        sender.togglePaused()
    }
}

// MARK: - Onboarding implementation

extension DebateViewController {
    private func showOnboarding() {
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
        let onboardingCardViewModels = [o0, o1, o2, o3, o4, o5]

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let onboarding = OnboardingViewController(collectionViewLayout: layout,
                                                  onboardingCardViewModels: onboardingCardViewModels)

        present(onboarding, animated: true, completion: { self.shouldShowOnboard = false })
    }
}
