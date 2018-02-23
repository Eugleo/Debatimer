//
//  CardesqueCollectionViewCell.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 20.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class CardesqueCollectionViewCell: UICollectionViewCell, Reusable {
    
    // MARK: Public UI Properties

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
        l.font = UIFont.boldSystemFont(ofSize: 35)
        l.textAlignment = .center
    }

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayer()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupLayer()
        setupConstraints()
    }

    // MARK: Private functions

    private func setupLayer() {
        layer.cornerRadius = Constants.UI.CornerRadius.standart
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
    }

    private func setupConstraints() {
        addSubview(titleLabel) { l in
            l.center.alignWithSuperview()
        }

        addSubview(topLabel, middleLabel, bottomLabel) { l1, l2, l3 in
            l1.leading.pinToSuperviewMargin()
            l1.top.pinToSuperviewMargin()
            l1.height.set(30)
            l1.width.set(30)

            l2.leading.pinToSuperviewMargin()
            l2.top.align(with: l1.bottom.offsetting(by: 10))
            l2.height.set(30)
            l2.width.set(30)

            l3.leading.pinToSuperviewMargin()
            l3.top.align(with: l2.bottom.offsetting(by: 10))
            l3.height.set(30)
            l3.width.set(30)
        }
        middleLabel.isHidden = true
        bottomLabel.isHidden = true
    }
}
