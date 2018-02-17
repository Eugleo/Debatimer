//
//  IntroCollectionViewCell.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class IntroCollectionViewCell: UICollectionViewCell {
    let titleLabel = UILabel { l in
        l.font = UIFont.systemFont(ofSize: 24, weight: .black)
        l.textColor = UIColor(named: "Affirmative")
        l.textAlignment = .center
    }

    let descriptionLabel = UILabel { l in
        l.font = UIFont.preferredFont(forTextStyle: .body)
        l.numberOfLines = 0
        l.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.removeFromSuperview()
        descriptionLabel.removeFromSuperview()

        addSubview(titleLabel, descriptionLabel) { t, d in
            d.top.align(with: self.al.centerY)
            d.leading.pinToSuperview(inset: 40, relation: .equal)
            d.trailing.pinToSuperview(inset: 40, relation: .equal)

            t.centerX.alignWithSuperview()
            t.bottom.align(with: d.top, offset: -15, multiplier: 1, relation: .equal)
        }
    }
}
