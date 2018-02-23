//
//  ShadowTappableLabel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 30.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import Yalta

protocol ShadowTappableLabelDelegate {
    func handleTapGesture(sender: ShadowTappableLabel)
}

class ShadowTappableLabel: UIView {
    var delegate: ShadowTappableLabelDelegate?

    private let shadowView = UIView().with { v in
        v.frame = .zero
        v.layer.shadowRadius = 8
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = .zero
        v.layer.shadowOpacity = 0
        v.clipsToBounds = false
    }

    private let backgroundView = UIView().with { v in
        v.layer.cornerRadius = 15
        v.backgroundColor = .white
        v.clipsToBounds = true
    }

    override var backgroundColor: UIColor? {
        get {
            return backgroundView.backgroundColor
        }
        set {
            backgroundView.backgroundColor = newValue
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 15)
        shadowView.layer.shadowPath = shadowPath.cgPath
    }

    private struct Transformations {
        static let bottom = CGAffineTransform(scaleX: 1, y: 1)
        static let middle = CGAffineTransform(scaleX: 1, y: 1)
        static let top = CGAffineTransform(scaleX: 1, y: 1)
        private init() { }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundColor = .clear

        insertSubview(shadowView, at: 0)
        Constraints.init(for: shadowView) { v in
            v.edges.pinToSuperview()
        }
        insertSubview(backgroundView, at: 1)
        Constraints.init(for: backgroundView) { v in
            v.edges.pinToSuperview()
        }

        configureGestureRecognizers()
    }

    init() {
        super.init(frame: .zero)

        backgroundColor = .clear

        insertSubview(shadowView, at: 0)
        Constraints.init(for: shadowView) { v in
            v.edges.pinToSuperview()
        }
        insertSubview(backgroundView, at: 1)
        Constraints.init(for: backgroundView) { v in
            v.edges.pinToSuperview()
        }

        configureGestureRecognizers()
    }

    private func configureGestureRecognizers() {
        isUserInteractionEnabled = true

        let longPressGestureRecognizer =
            UILongPressGestureRecognizer(target: self,
                                         action: #selector(handleLongPressGesture(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 0.000001
        addGestureRecognizer(longPressGestureRecognizer)
    }

    @objc private func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            handleLongPressBegan()
        case .ended, .cancelled:
            if bounds.contains(gestureRecognizer.location(in: self)) {
                handleLongPressEnded()
                delegate?.handleTapGesture(sender: self)
                didTap(sender: self)
            }
        case .changed:
            if !bounds.contains(gestureRecognizer.location(in: self)) {
                handleLongPressEnded()
            } else {
                handleLongPressBegan()
            }
        default:
            break
        }
    }

    func didTap(sender: ShadowTappableLabel) {

    }

    private func animateButtonPress(transformation: CGAffineTransform,
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

    private func handleLongPressEnded() {
        animateButtonPress(transformation: .identity, duration: 0.25)
    }
}
