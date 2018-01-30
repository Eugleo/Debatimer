//
//  ColorfulLabel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import Yalta

protocol SpeechLabelDelegate {
    func tapped(sender: SpeechLabel)
}

final class SpeechLabel: UIView {
    enum State {
        case empty, hasSpeech, hasCrossQuestions, hasSpeechAndCrossQuestions
    }

    private var state = State.empty {
        didSet {
            if state == .hasSpeech && oldValue != .hasSpeech {
                animateSpeechLabel()
            }

            if state == .hasCrossQuestions && oldValue != .hasCrossQuestions {
                animateCrossQuetionsLabel()
            }

            if state == .hasSpeechAndCrossQuestions && oldValue != .hasSpeechAndCrossQuestions {
                if oldValue == .hasCrossQuestions {
                    animateSpeechLabel()
                } else if oldValue == .hasSpeech {
                    animateCrossQuetionsLabel()
                } else {
                    animateSpeechLabel()
                    animateCrossQuetionsLabel()
                }
            }
        }
    }

    func animateSpeechLabel() {
        speechTimeLabel.alpha = 0
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.spacingView1.removeFromSuperview()
                        self.spacingView2.removeFromSuperview()
                        self.speakerStackView.addArrangedSubview(self.speechTimeLabel)
                        self.layoutIfNeeded()
                        self.speechTimeLabel.alpha = 1
        },
                       completion: nil)
    }

    func animateCrossQuetionsLabel() {
        crossQuestionsStackView.alpha = 0
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.superStackView.addArrangedSubview(self.crossQuestionsStackView)
                        Constraints(for: self.crossQuestionsLabel) { l in
                            l.height.set(30)
                            l.width.set(30)
                        }
                        self.layoutIfNeeded()
                        self.crossQuestionsStackView.alpha = 1
                        },
                       completion: nil)
    }

    public var delegate: SpeechLabelDelegate?
    public var viewModel: SpeechLabelViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                state = .empty
                return
            }

            if viewModel.speechTime != nil {
                if viewModel.crossQuestionTime != nil {
                    state = .hasSpeechAndCrossQuestions
                } else {
                    state = .hasSpeech
                }
            } else {
                if viewModel.crossQuestionTime != nil {
                    state = .hasCrossQuestions
                } else {
                    state = .empty
                }
            }

            speechTimeLabel.text = viewModel.speechTime
            crossQuestionsTimeLabel.text = viewModel.crossQuestionTime
            speakerLabel.text = viewModel.name
            speakerLabel.backgroundColor =
                viewModel.team == .affirmative ?
                    UIColor(named: "Affirmative") :
                    UIColor(named: "Negative")
        }
    }

    private let speakerLabel = CircledLabel()
    private let crossQuestionsLabel = CircledLabel()

    private let crossQuestionsTimeLabel = UILabel {
        $0.textColor = .lightGray
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 26)
    }

    private let speechTimeLabel = UILabel {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 26)
    }

    private let speakerStackView = UIStackView {
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.isUserInteractionEnabled = false
    }
    private let spacingView1 = UIView()
    private let spacingView2 = UIView()

    private let superStackView = UIStackView {
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.isUserInteractionEnabled = false
    }

    private let crossQuestionsStackView = UIStackView {
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.isUserInteractionEnabled = false
    }
    private let spacingViewA = UIView()
    private let spacingViewB = UIView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.backgroundColor = .clear

        insertSubview(shadowView, at: 0)
        Constraints.init(for: shadowView) { (v) in
            v.edges.pinToSuperview()
        }

        addSubview(backgroundView) {
            $0.edges.pinToSuperview()
        }

        addSubview(superStackView) {
            $0.edges.pinToSuperviewMargins()
        }
        superStackView.addArrangedSubview(speakerStackView)

        speakerStackView.insertArrangedSubview(spacingView1, at: 0)
        speakerStackView.insertArrangedSubview(speakerLabel, at: 1)
        speakerStackView.insertArrangedSubview(spacingView2, at: 2)

        crossQuestionsStackView.insertArrangedSubview(crossQuestionsLabel, at: 0)
        crossQuestionsStackView.insertArrangedSubview(crossQuestionsTimeLabel, at: 1)
        crossQuestionsLabel.backgroundColor = UIColor(named: "NeutralGray")
        crossQuestionsLabel.text = "?"

        Constraints(for: spacingView1, spacingView2) { (sv1, sv2) in
            sv1.width.match(sv2.width)
            sv1.height.match(sv2.height)
            sv1.height.set(1)
        }

        Constraints(for: self.speakerLabel) { l in
            l.height.set(30)
            l.width.set(30)
        }

        configureGestureRecognizers()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        speakerLabel.layer.cornerRadius = speakerLabel.frame.height / 2
        let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 15)
        shadowView.layer.shadowPath = shadowPath.cgPath
    }

    private struct Transformations {
        static let bottom = CGAffineTransform(scaleX: 0.975, y: 0.975)
        private init() { }
    }

    private struct Shadows {
        static let big: CGFloat = 3
        static let small: CGFloat = 1
        private init() { }
    }

    private let shadowView = UIView { sv in
        sv.frame = .zero
        sv.layer.masksToBounds = false
        sv.layer.shadowRadius = 7
        sv.layer.shadowColor = UIColor.black.cgColor
        sv.layer.shadowOffset = .zero
        sv.layer.shadowOpacity = 0.07
    }

    let backgroundView = UIView { v in
        v.layer.cornerRadius = 15
        v.backgroundColor = .white
        v.clipsToBounds = true
    }

    // MARK: - Gesture Recognizer

    private func configureGestureRecognizers() {
        isUserInteractionEnabled = true

        let longPressGestureRecognizer =
            UILongPressGestureRecognizer(target: self,
                                         action: #selector(handleLongPressGesture(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 0.000001
        addGestureRecognizer(longPressGestureRecognizer)
    }

    @objc internal func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            handleLongPressBegan()
        case .ended, .cancelled:
            if bounds.contains(gestureRecognizer.location(in: self)) {
                handleLongPressEndedInside()
            }
        case .changed:
            if !bounds.contains(gestureRecognizer.location(in: self)) {
                handleLongPressEndedOutside()
            } else {
                handleLongPressBegan()
            }
        default:
            break
        }
    }

    func animateButtonPress(transformation: CGAffineTransform,
                            duration: TimeInterval) {

        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0,
                       options: [.beginFromCurrentState, .allowUserInteraction],
                       animations: {
                        self.transform = transformation
        },
                       completion: nil)
    }

    private func handleLongPressBegan() {
        animateButtonPress(transformation: Transformations.bottom, duration: 0.25)
    }

    private func handleLongPressEndedInside() {
        animateButtonPress(transformation: .identity, duration: 0.25)
        delegate?.tapped(sender: self)
    }

    private func handleLongPressEndedOutside() {
        animateButtonPress(transformation: .identity, duration: 0.25)
    }
}
