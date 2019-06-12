//
//  Timer.swift
//  Debatimer
//
//  Created by Evžen Wybitul on 12.11.17.
//  Copyright © 2017 Evžen Wybitul. All rights reserved.
//

import Foundation

class Stopwatch {
    private var intervalStartTime: Date?
    private var lastInterval: TimeInterval?
    
    func startNewInterval() {
        lastInterval = currentIntervalLength()
        intervalStartTime = Date()
    }
    
    func currentIntervalLength() -> TimeInterval? {
        guard let intervalStartTime = intervalStartTime else { return nil }
        return Date().timeIntervalSince(intervalStartTime)
    }
    
    func lastIntervalLength() -> TimeInterval? {
        return lastInterval
    }
}

struct CountdownTimer {
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
