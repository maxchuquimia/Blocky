//
//  AppDelegate.swift
//  Blocky
//
//  Created by Max Chuquimia on 15/9/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let filterDataSource = FilterDataSource()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if Persistence.didWriteExampleFilters.value != true && filterDataSource.readFilters().isEmpty {
            Persistence.didWriteExampleFilters.value = true

            let examples = [
                Filter(identifier: UUID(), name: "“STOP” Filter", rule: .suffix(string: "STOP"), isCaseSensitive: true, order: 0),
                Filter(identifier: UUID(), name: ".xyz URL Filter", rule: .regex(expression: "(http:|https:).*\\.xyz"), isCaseSensitive: false, order: 1),
                Filter(identifier: UUID(), name: "“Final Notice” Filter", rule: .contains(substrings: ["Final Notice", "overdue"]), isCaseSensitive: false, order: 0),
            ]

            filterDataSource.write(filters: examples)
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

