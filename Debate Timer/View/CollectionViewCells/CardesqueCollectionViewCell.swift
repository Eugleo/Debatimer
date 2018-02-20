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
    let topLabel: CircledLabel = {
        let l = CircledLabel()
        l.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return l
    }()

    let middleLabel: CircledLabel = {
        let l = CircledLabel()
        l.backgroundColor = UIColor(white: 1, alpha: 0.3)
        l.text = "⨯"
        return l
    }()

    let bottomLabel: CircledLabel = {
        let l = CircledLabel()
        l.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return l
    }()

    let titleLabel = UILabel {
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 35)
        $0.textAlignment = .center
    }

    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupLayer()
        setupConstraints()
    }

    // MARK: Private functions
    private func setupLayer() {
        layer.cornerRadius = 20
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
