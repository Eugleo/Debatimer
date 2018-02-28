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
    private static let runCountKey = "runCount"
    private static let requestCountKey = "requestCount"
    static let minimumCount = 4

    static func incrementRunCount() {
        let runs = getRunCount()
        UserDefaults.standard.setValue(runs + 1, forKey: runCountKey)
    }

    static func getRunCount() -> Int {
        return UserDefaults.standard.integer(forKey: runCountKey)
    }

    static func getRequestCount() -> Int {
        return UserDefaults.standard.integer(forKey: requestCountKey)
    }

    static func showReview() {
        let runs = getRunCount()
        let requests = getRequestCount()

        // Ask every 4th launch
        if runs > (requests + 1) * minimumCount {
            SKStoreReviewController.requestReview()
            UserDefaults.standard.setValue(requests + 1, forKey: runCountKey)
        }
    }
}
