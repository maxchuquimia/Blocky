//
//  BlockyUITests.swift
//  BlockyUITests
//
//  Created by Max Chuquimia on 15/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import XCTest

class BlockyAppPreview: XCTestCase {

    var app: BlockyApp!
    var onboardingScreen: OnboardingScreen!
    var listScreen: ListScreen!
    var detailScreen: DetailScreen!

    let tinyDelay: TimeInterval = 0.5
    let shortDelay: TimeInterval = 1.5
    let longDelay: TimeInterval = 4

    override func setUpWithError() throws {
        app = BlockyApp()
        onboardingScreen = OnboardingScreen(app: app)
        listScreen = ListScreen(app: app)
        detailScreen = DetailScreen(app: app)
    }

    func preview1() throws {
        app.screenshot(filename: "screenshot_3.png")
        app.tap(onboardingScreen.nextPageButton)
        app.pause(for: shortDelay)
        app.screenshot(filename: "screenshot_4.png")
        app.tap(onboardingScreen.nextPageButton)
        app.pause(for: shortDelay)
        app.screenshot(filename: "screenshot_5.png")
        app.tap(onboardingScreen.nextPageButton)
        app.pause(for: shortDelay)
        app.screenshot(filename: "screenshot_6.png")
        app.tap(onboardingScreen.closeButton)
        app.pause(for: shortDelay)

        app.screenshot(filename: "screenshot_1.png")

        app.tap(listScreen.newFilterButton)
        app.pause(for: shortDelay)

        app.tap(detailScreen.endsWithFilterOption)

        app.tap(detailScreen.firstValueField)
        app.typeText("Final Notice:")
        app.tap(detailScreen.testZoneField)
        app.typeText("Final Notice: If submission is not received by 5pm you will forfeit your requested amount-and-transfer preferences: http://rrvfl.xyz/y2hrem")
        app.tap(detailScreen.background)
        app.pause(for: tinyDelay)

        app.scrollDown(detailScreen.scrollView)
        app.pause(for: tinyDelay)
        app.scrollRight(detailScreen.helpCards)
        app.pause(for: shortDelay)
        app.scrollUp(detailScreen.scrollView)

        app.tap(detailScreen.startsWithFilterOption)
        app.pause(for: longDelay)
        app.screenshot(filename: "screenshot_2.png")
        app.tap(detailScreen.saveButton)

        app.pause(for: longDelay)
    }

}
