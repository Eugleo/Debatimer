//
//  AppDelegate.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        Reviewer.incrementRunCount()
        application.isIdleTimerDisabled = true

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = DebateViewController()
        window?.makeKeyAndVisible()

        return true
    }
}
