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

    enum ViewState {

        struct Configuration {
            let enabledFilters: [Filter]
            let disabledFilters: [Filter]
            let isEnabledInSettings: Bool
        }

        case loaded(Configuration)

        static let initial: ViewState = .loaded(Configuration(enabledFilters: [], disabledFilters: [], isEnabledInSettings: true))
    }

}
