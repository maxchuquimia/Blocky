//
//  TestingSupport.swift
//  Blocky
//
//  Created by Max Chuquimia on 15/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

enum AI {

    enum PageView {
        static let scrollView = "AI.PageView.scrollView"
        static let close = "AI.PageView.close"
        static let nextPage = "AI.PageView.nextPage"
    }

    enum FilterList {
        static let newFilterButton = "AI.FilterList.newFilterButton"
    }

    enum ListView {
        static func option(at index: Int) -> String {
            "AI.ListView.option\(index)"
        }
    }

    enum FilterDetail {
        static let firstValueTextView = "AI.FilterDetail.firstValueTextView"
        static let testZoneTextView = "AI.FilterDetail.testZoneTextView"

        static let saveButton = "AI.FilterDetail.saveButton"
        static let background = "AI.FilterDetail.closeKeyboard"

        static let mainScrollView = "AI.FilterDetail.mainScrollView"
        static let helpScrollView = "AI.FilterDetail.helpScrollView"
    }

}
