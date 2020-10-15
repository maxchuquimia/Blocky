//
//  ListScreen.swift
//  BlockyUITests
//
//  Created by Max Chuquimia on 15/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import XCTest

class ListScreen {

    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    var newFilterButton: XCUIElement { app.buttons[AI.FilterList.newFilterButton] }

}
