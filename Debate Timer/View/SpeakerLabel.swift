//
//  ColorfulLabel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import Yalta
import DeviceKit

final class SpeakerLabel: ShadowTappableLabel {
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

            if state == .empty && oldValue != .empty {
                animateResetting()
            }
        }
    }

    private var activated = false
    
    func activate() {

    }

    func deactivate() {

    }

    override init() {
        super.init()

        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(superStackView) {
            $0.edges.pinToSuperviewMargins(insets: insets, relation: .equal)
        }
        superStackView.addArrangedSubview(speakerStackView)

        speakerStackView.insertArrangedSubview(spacingView1, at: 0)
        speakerStackView.insertArrangedSubview(speakerLabel, at: 1)
        speakerStackView.insertArrangedSubview(spacingView2, at: 2)

        crossQuestionsStackView.insertArrangedSubview(crossQuestionsLabel, at: 0)
        crossQuestionsStackView.insertArrangedSubview(crossQuestionsTimeLabel, at: 1)
        crossQuestionsLabel.backgroundColor = UIColor(named: "NeutralGray")
        crossQuestionsLabel.text = "⨯"

        Constraints(for: spacingView1, spacingView2) { (sv1, sv2) in
            sv1.width.match(sv2.width)
            sv1.height.match(sv2.height)
            sv1.height.set(2)
        }

        Constraints(for: self.speakerLabel) { l in
            if Device().isPad {
                l.height.set(45)
                l.width.set(45)
            } else {
                l.height.set(30)
                l.width.set(30)
            }
        }
        speakerLabel.text = "A"

        clipsToBounds = false
        backgroundColor = .clear

        if Device().isPad {
            setupViewsForIPad()
        } else {
            setupViewsForIPhone()
        }

        // Add the mockup views to the view
        addSubview(mockupSuperStackView) {
            $0.edges.pinToSuperviewMargins(insets: insets, relation: .equal)
        }
        mockupSuperStackView.addArrangedSubview(mockupLabel1)
        mockupSuperStackView.addArrangedSubview(mockupLabel2)
    }

    private func setupViewsForIPad() {
        speakerLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        crossQuestionsLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)

        speechTimeLabel.font = UIFont.boldSystemFont(ofSize: 28)
        crossQuestionsTimeLabel.font = UIFont.boldSystemFont(ofSize: 28)

        Constraints(for: self.speakerLabel) { l in
            l.height.set(45)
            l.width.set(45)
        }
    }

    private func setupViewsForIPhone() {
        Constraints(for: self.speakerLabel) { l in
            l.height.set(30)
            l.width.set(30)
        }
    }

    private func animateResetting() {
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.speakerStackView.removeArrangedSubview(self.speechTimeLabel)
                        self.speechTimeLabel.removeFromSuperview()
                        self.superStackView.removeArrangedSubview(self.crossQuestionsStackView)
                        self.crossQuestionsStackView.removeFromSuperview()

                        self.speakerStackView.insertArrangedSubview(self.spacingView1, at: 0)
                        self.speakerStackView.insertArrangedSubview(self.spacingView2, at: 2)

                        Constraints(for: self.spacingView1, self.spacingView2) { (sv1, sv2) in
                            sv1.width.match(sv2.width)
                            sv1.height.match(sv2.height)
                            sv1.height.set(2)
                        }

                        self.layoutIfNeeded()
        },
                       completion: {_ in
                        self.crossLabelAnimated = false
                        self.speechLabelAnimated = false
        })
    }

    private var speechLabelAnimated = false
    private func animateSpeechLabel() {
        speechTimeLabel.alpha = 0
        speakerLabel.layer.removeAllAnimations()
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
                       completion: {_ in self.speechLabelAnimated = true })
    }

    private var crossLabelAnimated = false
    private func animateCrossQuetionsLabel() {
        crossQuestionsStackView.alpha = 0
        self.speakerLabel.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.superStackView.addArrangedSubview(self.crossQuestionsStackView)
                        Constraints(for: self.crossQuestionsLabel) { l in
                            l.height.set(Device().isPhone ? 30 : 45)
                            l.width.set(Device().isPhone ? 30 : 45)
                        }
                        self.layoutIfNeeded()
                        self.crossQuestionsStackView.alpha = 1
                        },
                       completion: {_ in self.crossLabelAnimated = true })
    }

    private var bcg: UIColor?


    public var viewModel: SpeakerLabelViewModel? {
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

            speechTimeLabel.text =  viewModel.speechTime
            crossQuestionsTimeLabel.text = viewModel.crossQuestionTime
            speakerLabel.text = viewModel.name
            speakerLabel.backgroundColor =
                viewModel.team == .affirmative ?
                    UIColor(named: "Affirmative") :
                    UIColor(named: "Negative")

            bcg = speakerLabel.backgroundColor

            speechTimeLabel.textColor = viewModel.speechTimeColor
            crossQuestionsTimeLabel.textColor = viewModel.crossTimeColor
        }
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: interval)!
    }

    private let speakerLabel = CircledLabel()
    private let crossQuestionsLabel = CircledLabel()

    private let crossQuestionsTimeLabel = UILabel().with {
        $0.textColor = .lightGray
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 22)
    }

    private let speechTimeLabel = UILabel().with {
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 22)
    }

    private let speakerStackView = UIStackView().with {
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.isUserInteractionEnabled = false
    }
    private let spacingView1 = UIView()
    private let spacingView2 = UIView()

    private let superStackView = UIStackView().with {
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.axis = .vertical
        //$0.spacing = 7
        $0.isUserInteractionEnabled = false
    }

    private let crossQuestionsStackView = UIStackView().with {
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.isUserInteractionEnabled = false
    }
    private let spacingViewA = UIView()
    private let spacingViewB = UIView()

    // Mockup views, so that the cell has the correct height even if empty

    private let mockupSuperStackView = UIStackView().with {
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.spacing = 7
        $0.isUserInteractionEnabled = false
    }

    private let mockupLabel1 = UILabel().with { l in
        l.text = " "
        l.font = UIFont.boldSystemFont(ofSize: 26)
    }

    private let mockupLabel2 = UILabel().with { l in
        l.text = " "
        l.font = UIFont.boldSystemFont(ofSize: 26)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(superStackView) {
            $0.edges.pinToSuperviewMargins(insets: insets, relation: .equal)
        }
        superStackView.addArrangedSubview(speakerStackView)

        speakerStackView.insertArrangedSubview(spacingView1, at: 0)
        speakerStackView.insertArrangedSubview(speakerLabel, at: 1)
        speakerStackView.insertArrangedSubview(spacingView2, at: 2)

        crossQuestionsStackView.insertArrangedSubview(crossQuestionsLabel, at: 0)
        crossQuestionsStackView.insertArrangedSubview(crossQuestionsTimeLabel, at: 1)
        crossQuestionsLabel.backgroundColor = UIColor(named: "NeutralGray")
        crossQuestionsLabel.text = "⨯"

        Constraints(for: spacingView1, spacingView2) { (sv1, sv2) in
            sv1.width.match(sv2.width)
            sv1.height.match(sv2.height)
            sv1.height.set(2)
        }

        Constraints(for: self.speakerLabel) { l in
            l.height.set(30)
            l.width.set(30)
        }
        speakerLabel.text = "A"

        clipsToBounds = false
        backgroundColor = .clear

        // Add the mockup views to the view
        addSubview(mockupSuperStackView) {
            $0.edges.pinToSuperviewMargins(insets: insets, relation: .equal)
        }
        mockupSuperStackView.addArrangedSubview(mockupLabel1)
        mockupSuperStackView.addArrangedSubview(mockupLabel2)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        speakerLabel.layer.cornerRadius = speakerLabel.frame.height / 2
    }
}
