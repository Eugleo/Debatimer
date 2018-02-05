//
//  RoundedCollectionViewCell.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 05.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class RoundedCollectionViewCell: UICollectionViewCell {
    static let reuseID = "StartOverCollectionViewCell"

    private let timeLabel = UILabel {
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 35)
        $0.textAlignment = .center
        $0.text = "Začít znovu"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        layer.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

        addSubview(timeLabel) {
            $0.center.alignWithSuperview()
        }
    }
}
