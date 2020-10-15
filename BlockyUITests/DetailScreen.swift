//
//  DetailScreen.swift
//  BlockyUITests
//
//  Created by Max Chuquimia on 15/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import XCTest

class DetailScreen {

    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    var saveButton: XCUIElement { app.buttons[AI.FilterDetail.saveButton] }
    var background: XCUICoordinate {
        app.otherElements[AI.FilterDetail.background]
            .coordinate(withNormalizedOffset: .zero)
            .withOffset(CGVector(dx: 5, dy: 80))
    }

    var firstValueField: XCUIElement { app.textViews[AI.FilterDetail.firstValueTextView] }
    var testZoneField: XCUIElement { app.textViews[AI.FilterDetail.testZoneTextView] }

    var containsFilterOption: XCUIElement { app.buttons[AI.ListView.option(at: 0)] }
    var startsWithFilterOption: XCUIElement { app.buttons[AI.ListView.option(at: 1)] }
    var endsWithFilterOption: XCUIElement { app.buttons[AI.ListView.option(at: 3)] }
    var regexFilterOption: XCUIElement { app.buttons[AI.ListView.option(at: 4)] }

    var scrollView: XCUIElement { app.scrollViews[AI.FilterDetail.mainScrollView] }
    var helpCards: XCUIElement { app.scrollViews[AI.FilterDetail.helpScrollView] }
}
