//
//  PauseButton.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 12.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

protocol PauseButtonDelegate {
    func pauseButtonTapped(sender: PauseButton)
}

class PauseButton: UIView {

    // MARK: - Public properties

    var delegate: PauseButtonDelegate?

    var gradientColors: [UIColor]? {
        didSet {
            guard let colors = gradientColors else { return }
            gradientLayer.colors = colors.map { $0.cgColor }
        }
    }

    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                isUserInteractionEnabled = true
            } else {
                isUserInteractionEnabled = false
            }
            updateBackgroundColor()
        }
    }

    // MARK: - Private UI properties

    private let playPauseView = PausableView()
    private let teamLabel = CircledLabel()
    private let gradientLayer = CAGradientLayer()
    private let shadowLayer = CAShapeLayer()

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)

        backgroundColor = .clear

        setupLayer()
        setupConstraints()
        setupGestureRecognizers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        fatalError("Not yet implemented init(coder:)")
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        gradientLayer.frame = frame

        let radius = frame.height / 2
        let shadowBounds = CGRect(x: bounds.minX + 1, y: bounds.minY, width: bounds.width - 2, height: bounds.height)
        let radiusPath = UIBezierPath(roundedRect: shadowBounds, cornerRadius: radius).cgPath

        shadowLayer.removeFromSuperlayer()
        shadowLayer.path = radiusPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 3.0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 4
        layer.insertSublayer(shadowLayer, at: 0)

        gradientLayer.cornerRadius = radius
        layer.cornerRadius = radius

        gradientLayer.frame = frame
        shadowLayer.frame = frame
    }

    // MARK: - Private functions

    private func setupLayer() {
        layer.insertSublayer(gradientLayer, at: 1)
        layer.masksToBounds = false
    }

    private func setupConstraints() {
        addSubview(teamLabel) { l in
            l.edges.pinToSuperview()
        }

        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        teamLabel.addSubview(playPauseView) { v in
            v.edges.pinToSuperviewMargins(insets: insets, relation: .equal)
        }
    }

    private func setupGestureRecognizers() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(gr)
        isUserInteractionEnabled = true
    }

    private func updateBackgroundColor() {
        if isEnabled {
            gradientLayer.colors = gradientColors!.map { $0.cgColor }
            animateChange(hideShadow: false, transformation: .identity)
        } else {
            let colors = Constants.UI.GradientColors.gray
            gradientLayer.colors = colors.map { $0.cgColor }
            animateChange(hideShadow: true, transformation: Constants.UI.Transformations.large)
        }
    }

    private func animateChange(hideShadow: Bool, transformation: CGAffineTransform) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.transform = transformation
                        if hideShadow {
                            self.shadowLayer.removeFromSuperlayer()
                        } else {
                            self.shadowLayer.removeFromSuperlayer()
                            self.layer.insertSublayer(self.shadowLayer, at: 0)
                        }
                       },
                       completion: nil)
    }

    @objc private func didTap() {
        delegate?.pauseButtonTapped(sender: self)
    }

    // MARK: - Public functions

    public func togglePaused(to state: Bool? = nil) {
        if let state = state {
            playPauseView.isPaused = state
        } else {
            playPauseView.isPaused = !playPauseView.isPaused!
        }
    }
}
