//
//  CardesqueCollectionViewCell.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 20.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import Yalta
import DeviceKit

class CardesqueCollectionViewCell: UICollectionViewCell, Reusable {

    // MARK: - Public properties

    var gradientColors: [UIColor]? {
        didSet {
            guard let colors = gradientColors else { return }
            gradientLayer.colors = colors.map { $0.cgColor }
        }
    }
    
    // MARK: - Public UI Properties

    let topLabel = CircledLabel().with { l in
        l.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }

    let middleLabel = CircledLabel().with { l in
        l.backgroundColor = UIColor(white: 1, alpha: 0.3)
        l.text = "⨯"
    }

    let bottomLabel = CircledLabel().with { l in
        l.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }

    let titleLabel = UILabel().with { l in
        l.textColor = .white
        l.font = UIFont.boldSystemFont(ofSize: 34)
        l.textAlignment = .center
    }

    // MARK: - Private UI properties

    private let stackView = UIStackView().with { s in
        s.alignment = .fill
        s.axis = .vertical
        s.distribution = .equalSpacing
        s.spacing = 10
    }

    private let gradientLayer = CAGradientLayer()
    private let shadowLayer = CAShapeLayer()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayer()
        setupConstraints()
        if Device().isPad {
            setupViewsOnIPad()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Required init(coder aDecoder: NSCoder) not yet implemented!")
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        gradientLayer.frame = frame

        let radius = Constants.UI.CornerRadius.standart
        let shadowBounds = CGRect(x: bounds.minX + 5, y: bounds.minY, width: bounds.width - 10, height: bounds.height)
        let radiusPath = UIBezierPath(roundedRect: shadowBounds, cornerRadius: radius).cgPath

        shadowLayer.removeFromSuperlayer()
        shadowLayer.path = radiusPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 5.0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 4
        layer.insertSublayer(shadowLayer, at: 0)

        shadowLayer.frame = frame
    }

    // MARK: - Private functions

    private func setupViewsOnIPad() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 48)
        topLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        middleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        bottomLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
    }

    private func setupLayer() {
        let radius = Constants.UI.CornerRadius.standart

        gradientLayer.cornerRadius = radius
        layer.insertSublayer(gradientLayer, at: 1)

        layer.cornerRadius = radius
        layer.masksToBounds = false
    }

    private func setupConstraints() {
        addSubview(stackView) { s in
            s.top.pinToSuperviewMargin()
            s.leading.pinToSuperviewMargin()
            s.width.set(Device().isPhone ? 30 : 45)

            if Device().isOneOf([.iPhoneSE, .simulator(.iPhoneSE)]) {
                s.bottom.pinToSuperviewMargin()
            }
        }
        stackView.insertArrangedSubviews([topLabel, middleLabel, bottomLabel])

        addSubview(titleLabel) { l in
            l.center.alignWithSuperview()
        }

        Constraints(for: topLabel, middleLabel, bottomLabel) { l1, l2, l3 in
            l1.height.set(Device().isPhone ? 30 : 45)
            l1.width.set(Device().isPhone ? 30 : 45)
            l2.height.set(Device().isPhone ? 30 : 45)
            l2.width.set(Device().isPhone ? 30 : 45)
            l3.height.set(Device().isPhone ? 30 : 45)
            l3.width.set(Device().isPhone ? 30 : 45)
        }
        middleLabel.alpha = 0
        bottomLabel.alpha = 0
    }
}
