//
//  Constants.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 23.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

enum Format {
    static func formatTimeInterval(_ ti: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: ti)!
    }
}

enum Info {
    static func isDevicePhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

enum Constants {
    static let crossQuestionTime: TimeInterval = 180

    enum UI {
        enum Spacing {
            static let large: CGFloat = 15
            static let medium: CGFloat = 15
        }

        enum Colors {
            static let affirmative = UIColor(named: "Affirmative")!
            static let negative = UIColor(named: "Negative")!
            static let affirmativeLight = UIColor(named: "LightBlue")!
            static let negativeLight = UIColor(named: "LightRed")!
            static let almostWhite = UIColor(named: "CreamWhite")!
            static let gray = UIColor(named: "NeutralGray")!
            static let errorDarkRed = UIColor(named: "DarkRedError")!
            static let errorLightRed = UIColor(named: "LightRedError")!
        }

        enum GradientColors {
            static let affirmative = [UIColor(named: "AffirmativeGradient")!, Constants.UI.Colors.affirmative]
            static let negative = [UIColor(named: "NegativeGradient")!, Constants.UI.Colors.negative]
            static let gray = [UIColor(named: "NeutralGrayGradient")!, Constants.UI.Colors.gray]
        }

        enum CornerRadius {
            static let standart: CGFloat = 20
            static let medium: CGFloat = 15
        }

        enum Transformations {
            static let small2 = CGAffineTransform(scaleX: 0.95, y: 0.95)
            static let small1 = CGAffineTransform(scaleX: 0.99, y: 0.99)
            static let large1 = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }

        enum Shadows {
            static let large: CGFloat = 6
            static let medium: CGFloat = 4
        }
    }
}
