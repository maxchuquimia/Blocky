//
//  OnboardingScreen.swift
//  BlockyUITests
//
//  Created by Max Chuquimia on 15/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import XCTest

class OnboardingScreen {

    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    var scrollview: XCUIElement { app.scrollViews[AI.PageView.scrollView] }
    var closeButton: XCUIElement { app.buttons[AI.PageView.close] }
    var nextPageButton: XCUIElement { app.buttons[AI.PageView.nextPage] }

}
