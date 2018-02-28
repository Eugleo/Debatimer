//
//  SpeakerCoupleView.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 22.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class SpeakerLabelStackView: UIView {

    // MARK: - Public properties18

    var delegate: ShadowTappableLabelDelegate? {
        didSet {
            [speechLabel1, speechLabel2, speechLabel3].forEach { $0.delegate = delegate }
        }
    }

    // MARK: - Private UI properties

    private let stackView = UIStackView().with { v in
        v.alignment = .fill
        v.axis = .vertical
        v.distribution = .fillEqually
        v.spacing = Constants.UI.Spacing.medium
    }

    let speechLabel1 = SpeakerLabel()
    let speechLabel2 = SpeakerLabel()
    let speechLabel3 = SpeakerLabel()

    // MARK: - Initialization

    init(vm1: SpeakerLabelViewModel, vm2: SpeakerLabelViewModel, vm3: SpeakerLabelViewModel) {
        super.init(frame: .zero)

        setupConstraints()

        speechLabel1.viewModel = vm1
        speechLabel2.viewModel = vm2
        speechLabel3.viewModel = vm3

        stackView.insertArrangedSubviews([speechLabel1, speechLabel2, speechLabel3])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private functions

    private func setupConstraints() {
        stackView.removeFromSuperview()

        addSubview(stackView) { v in
            v.edges.pinToSuperview()
        }
    }

     // MARK: - Public functions

    func reset(vm1: SpeakerLabelViewModel, vm2: SpeakerLabelViewModel, vm3: SpeakerLabelViewModel) {
        speechLabel1.viewModel = vm1
        speechLabel2.viewModel = vm2
        speechLabel3.viewModel = vm3
    }

    func setActivated(ofLabelNo n: Int, to state: Bool) {
        if n == 0 {
            if state {
                speechLabel1.activate()
            } else {
                speechLabel1.deactivate()
            }
        } else if n == 1 {
            if state {
                speechLabel2.activate()
            } else {
                speechLabel2.deactivate()
            }
        } else if n == 2 {
            if state {
                speechLabel3.activate()
            } else {
                speechLabel3.deactivate()
            }
        }
    }

    func setViewModel(ofLabelNo index: Int, to model: SpeakerLabelViewModel) {
        if index == 0 {
            speechLabel1.viewModel = model
        } else if index == 1 {
            speechLabel2.viewModel = model
        } else if index == 2 {
            speechLabel3.viewModel = model
        }
    }
}
