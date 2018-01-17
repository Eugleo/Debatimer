//
//  ColorfulLabel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import Cartography

final class ColorfulLabel: UIView {
    @IBInspectable public var text: String? {
        didSet {
            titleLabel.text = text
        }
    }

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = UIFont.boldSystemFont(ofSize: 30)
        l.textAlignment = .center
        return l
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(titleLabel)
        constrain(titleLabel) { l in
            l.edges == l.superview!.edges
        }
        layer.backgroundColor = UIColor(named: "AffirmativeColor")?.cgColor
        backgroundColor = UIColor(named: "AffirmativeColor")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }
}
