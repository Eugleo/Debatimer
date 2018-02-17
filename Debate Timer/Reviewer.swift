//
//  Reviewer.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import Foundation
import StoreKit

struct Reviewer {
    static let runCountKey = "runCount"
    static let minimumCount = 3

    static func incrementRunCount() {
        let runs = getRunCount() + 1
        UserDefaults.standard.setValue(runs, forKey: runCountKey)
    }

    static func getRunCount() -> Int {
        let runs = UserDefaults.standard.value(forKey: runCountKey)

        return runs as? Int ?? 0
    }

    static func showReview() {
        let runs = getRunCount()

        if runs > minimumCount {
            SKStoreReviewController.requestReview()
        }
    }
}
