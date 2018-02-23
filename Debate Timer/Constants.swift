//
//  Constants.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 23.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

enum Constants {
    enum UI {
        enum Spacing {
            static let large: CGFloat = 20
            static let medium: CGFloat = 15
        }

        enum Colors {
            static let affirmative = UIColor(named: "Affirmative")!
            static let negative = UIColor(named: "Negative")!
            static let affirmativeLight = UIColor(named: "LightBlue")!
            static let negativeLight = UIColor(named: "LightRed")!
            static let almostWhite = UIColor(named: "CreamWhite")!
            static let gray = UIColor(named: "NeutralGray")!
        }

        enum CornerRadius {
            static let standart: CGFloat = 20
            static let medium: CGFloat = 15
        }
    }
}
