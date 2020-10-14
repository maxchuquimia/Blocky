//
//  FilterListDisplayModels.swift
//  Blocky
//
//  Created by Max Chuquimia on 8/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

enum FilterList {

}

extension FilterList {

    enum ViewState: Equatable {

        struct Configuration: Equatable {
            let allFilters: [Filter]
            let isEnabledInSettings: Bool
        }

        case loaded(Configuration)

        static let initial: ViewState = .loaded(Configuration(allFilters: [], isEnabledInSettings: true))

        static func == (lhs: FilterList.ViewState, rhs: FilterList.ViewState) -> Bool {
            switch (lhs, rhs) {
            case (let .loaded(a), let .loaded(b)): return a == b
            }
        }
    }

}
