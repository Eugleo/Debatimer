//
//  EndingCollectionViewCell.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

protocol EndingCollectionViewCellDelegate {
    func buttonTapped()
}

class EndingCollectionViewCell: UICollectionViewCell, Reusable {
    var delegate: EndingCollectionViewCellDelegate?

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

    private let button = UIButton().with { b in
        b.layer.cornerRadius = 15
        b.contentEdgeInsets = UIEdgeInsets(top: 25, left: 15, bottom: 25, right: 15)
        b.setTitle("Ukončit prohlídku", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        b.backgroundColor = UIColor(named: "Affirmative")
        b.setTitleColor(.white, for: .normal)
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
            d.top.align(with: self.al.centerY, offset: -40, multiplier: 1, relation: .equal)
            d.leading.pinToSuperview(inset: 40, relation: .equal)
            d.trailing.pinToSuperview(inset: 40, relation: .equal)

            t.centerX.alignWithSuperview()
            t.bottom.align(with: d.top, offset: -15, multiplier: 1, relation: .equal)
        }

        addSubview(button) { b in
            b.centerX.alignWithSuperview()
            b.top.align(with: descriptionLabel.al.bottom, offset: 50, multiplier: 1, relation: .equal)
        }
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @objc private func didTapButton(sender: UIButton) {
        delegate?.buttonTapped()
    }
}
