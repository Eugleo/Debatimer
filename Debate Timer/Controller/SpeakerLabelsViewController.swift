//
//  SpeakerLabelsViewController.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 23.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import Yalta

class SpeakerLabelsViewController: UIViewController {

    // MARK: - Private UI properties

    private let stackView = UIStackView().with { v in
        v.alignment = .fill
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.spacing = Constants.UI.Spacing.large
    }

    private let affirmativeSpeakerLabelStack: SpeakerLabelStackView
    private let negativeSpeakerLabelStack: SpeakerLabelStackView

    private let affirmativeBackgroundView = UIView().with { v in
        v.backgroundColor = Constants.UI.Colors.affirmativeLight
        v.layer.cornerRadius = Constants.UI.CornerRadius.standart
    }

    private let negativeBackgroundView = UIView().with { v in
        v.backgroundColor = Constants.UI.Colors.negativeLight
        v.layer.cornerRadius = Constants.UI.CornerRadius.standart
    }

    private var speakerLabels: [SpeakerLabel]

    // MARK: - Initialization

    init(vm1: SpeakerLabelViewModel,
         vm2: SpeakerLabelViewModel,
         vm3: SpeakerLabelViewModel,
         vm4: SpeakerLabelViewModel,
         vm5: SpeakerLabelViewModel,
         vm6: SpeakerLabelViewModel) {

        affirmativeSpeakerLabelStack = SpeakerLabelStackView(vm1: vm1, vm2: vm2, vm3: vm3)
        negativeSpeakerLabelStack = SpeakerLabelStackView(vm1: vm4, vm2: vm5, vm3: vm6)

        speakerLabels =
            [affirmativeSpeakerLabelStack.speechLabel1,
             negativeSpeakerLabelStack.speechLabel1,
             affirmativeSpeakerLabelStack.speechLabel2,
             negativeSpeakerLabelStack.speechLabel2,
             affirmativeSpeakerLabelStack.speechLabel3,
             negativeSpeakerLabelStack.speechLabel3]

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let parent = parent as? ShadowTappableLabelDelegate {
            affirmativeSpeakerLabelStack.delegate = parent
            negativeSpeakerLabelStack.delegate = parent
        }

        setupViews()
    }

    // MARK: - Private functions

    private func setupViews() {
        view.addSubview(stackView) { v in
            v.edges.pinToSuperview()
        }
        stackView.insertArrangedSubviews([affirmativeSpeakerLabelStack, negativeSpeakerLabelStack])

        view.insertSubview(affirmativeBackgroundView, belowSubview: stackView)
        view.insertSubview(negativeBackgroundView, belowSubview: stackView)

        Constraints(for: affirmativeBackgroundView, negativeBackgroundView) { a, n in
            a.top.align(with: stackView.al.top)
            a.bottom.align(with: stackView.al.bottom)
            a.leading.align(with: stackView.al.leading)
            a.width.match(affirmativeSpeakerLabelStack.al.width)

            n.top.align(with: stackView.al.top)
            n.bottom.align(with: stackView.al.bottom)
            n.trailing.align(with: stackView.al.trailing)
            n.width.match(negativeSpeakerLabelStack.al.width)
        }
    }

    // MARK: - Public functions

    func setActivated(ofLabelWithSpeaker speaker: SpeakerID, to state: Bool) {
        let label = speakerLabels.first {$0.viewModel?.speaker.id == speaker}!
        if state {
            label.activate()
        } else {
            label.deactivate()
        }
    }

    func setViewModel(ofLabelWithSpeaker speaker: SpeakerID, to model: SpeakerLabelViewModel) {
        let label = speakerLabels.first {$0.viewModel?.speaker.id == speaker}!
        label.viewModel = model
    }

    func reset(vm1: SpeakerLabelViewModel,
               vm2: SpeakerLabelViewModel,
               vm3: SpeakerLabelViewModel,
               vm4: SpeakerLabelViewModel,
               vm5: SpeakerLabelViewModel,
               vm6: SpeakerLabelViewModel) {

        affirmativeSpeakerLabelStack.reset(vm1: vm1, vm2: vm2, vm3: vm3)
        negativeSpeakerLabelStack.reset(vm1: vm4, vm2: vm5, vm3: vm6)
    }
}
