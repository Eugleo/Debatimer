//
//  ImageCollectionViewCell.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell, Reusable {
    let titleLabel = UILabel().with { l in
        l.font = UIFont.systemFont(ofSize: 24, weight: .black)
        l.textColor = UIColor(named: "Affirmative")
        l.textAlignment = .center
    }

    let descriptionLabel = UILabel().with { l in
        l.font = UIFont.preferredFont(forTextStyle: .body)
        l.numberOfLines = 0
        l.textAlignment = .center
    }

    let imageView = UIImageView().with { i in
        i.contentMode = .scaleAspectFit
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
        imageView.removeFromSuperview()

        addSubview(titleLabel, descriptionLabel, imageView) { t, d, i in
            d.leading.pinToSuperview(inset: 40, relation: .equal)
            d.trailing.pinToSuperview(inset: 40, relation: .equal)

            t.top.align(with: self.al.centerY, offset: 0, multiplier: 1.2, relation: .equal)
            t.centerX.alignWithSuperview()
            t.bottom.align(with: d.top, offset: -15, multiplier: 1, relation: .equal)

            i.top.pinToSuperview(inset: 90, relation: .equal)
            i.centerX.alignWithSuperview()
            i.bottom.align(with: t.top, offset: -25, multiplier: 1, relation: .equal)
        }
    }


}
