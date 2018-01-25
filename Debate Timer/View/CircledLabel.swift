//
//  CircledLabel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 20.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class CircledLabel: UIView {
    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }

    private let titleLabel = UILabel {
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textAlignment = .center
        $0.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        $0.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        clipsToBounds = true
        addSubview(titleLabel) {
            $0.edges.pinToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(titleLabel) {
            $0.edges.pinToSuperview()
        }
    }
}
