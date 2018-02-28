//
//  OnboardingCard.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation
import UIKit

struct OnboardingCardViewModel {
    enum Kind {
        case intro, image, ending
    }

    let title: String
    let description: String
    let image: UIImage?
    let kind: Kind

    init(title: String, description: String, kind: Kind, image: UIImage? = nil) {
        self.title = title
        self.description = description
        self.kind = kind
        self.image = image
    }
}
