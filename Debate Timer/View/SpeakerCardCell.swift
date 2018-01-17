//
//  SpeakerCardCell.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import Cartography

class SpeakerCardCell: UICollectionViewCell {
    var time: TimeInterval = 0 {
        didSet {
            timeLabel.text = formatTimeInterval(time)
        }
    }

    var speaker1 = "" {
        didSet {
            speaker1Label.text = speaker1
        }
    }

    var speaker2 = "" {
        didSet {
            speaker2Label.text = speaker2
            constrain(clear: speaker2LabelConstraints ?? ConstraintGroup())
            constrain(speaker1Label, speaker2Label) { s1, s2 in
                s2.left == s2.superview!.leftMargin
                s2.top == s1.bottom + 8
                s2.height == 27
                s2.width == 27
            }
        }
    }

    private var speaker1Label: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 12)
        l.textAlignment = .center
        l.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        l.layer.masksToBounds = true
        return l
    }()

    private var speaker2Label: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 12)
        l.textAlignment = .center
        l.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        l.layer.masksToBounds = true
        return l
    }()
    private var speaker2LabelConstraints: ConstraintGroup?

    private let timeLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = UIFont.boldSystemFont(ofSize: 35)
        l.textAlignment = .center
        return l
    }()

    private let gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.colors = [ UIColor(red:0.16, green:0.50, blue:0.73, alpha:1.0).cgColor,
                     UIColor(red:0.09, green:0.63, blue:0.52, alpha:1.0).cgColor]
        return l
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.cornerRadius = 15
        layer.addSublayer(gradientLayer)
        addSubview(timeLabel)
        constrain(timeLabel) { l in
            l.center == l.superview!.center
        }
        addSubview(speaker1Label)
        constrain(speaker1Label) { l in
            l.left == l.superview!.leftMargin
            l.top == l.superview!.topMargin
            l.height == 27
            l.width == 27
        }
        addSubview(speaker2Label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = layer.bounds
        speaker1Label.layer.cornerRadius = speaker1Label.frame.height / 2
        speaker2Label.layer.cornerRadius = speaker1Label.frame.height / 2
    }

    private func formatTimeInterval(_ ti: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: ti)!
    }
}
