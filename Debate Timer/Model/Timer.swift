//
//  Timer.swift
//  Debatimer
//
//  Created by Evžen Wybitul on 12.11.17.
//  Copyright © 2017 Evžen Wybitul. All rights reserved.
//

import Foundation

struct Timer {
    private var startTime: Date?
    private var interval: TimeInterval = 0
    private var accTime: TimeInterval = 0

    var timeLeft: TimeInterval {
        return interval - (accTime + Date().timeIntervalSince(startTime ?? Date()))
    }

    var elapsedTime: TimeInterval {
        return accTime + Date().timeIntervalSince(startTime ?? Date())
    }

    mutating func countdown(startingAt interval: TimeInterval) {
        self.interval = interval
        startTime = Date()
    }

    mutating func stop() {
        accTime = 0
        startTime = nil
    }

    func isRunning() -> Bool {
        return startTime != nil
    }

    mutating func pause() {
        accTime += Date().timeIntervalSince(startTime ?? Date())
        startTime = nil
    }

    mutating func unpause() {
        startTime = Date()
    }
}

