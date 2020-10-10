//
//  FilterListViewModel.swift
//  Blocky
//
//  Created by Max Chuquimia on 8/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation
import Combine

protocol FilterListController {
    var viewState: Variable<FilterList.ViewState> { get }
    func reorder(a: IndexPath, to b: IndexPath)
}

extension FilterList {

    class Controller: FilterListController {

        internal var viewState: Variable<ViewState> = .init(value: .initial)

        private var enabledFilters: [Filter] = []
        private var disabledFilters: [Filter] = []

        init() {

            enabledFilters = [
                Filter(name: "Some filter", rule: .exact(string: "This is a SPAM text message so yeah"), isCaseSensitive: false),
                Filter(name: "Another filter", rule: .prefix(string: "Final Notice:"), isCaseSensitive: false),
                Filter(name: "Even more filter", rule: .regex(expression: ".*http.*"), isCaseSensitive: true),
            ]

            disabledFilters = [
                Filter(name: "This one is disabled", rule: .exact(string: "test"), isCaseSensitive: false),
            ]


            load()
        }

    }

}

extension FilterList.Controller {

    func reorder(a: IndexPath, to b: IndexPath) {
        let targetItem: Filter

        if a.section == 0 {
            targetItem = enabledFilters.remove(at: a.row)
        } else {
            targetItem = disabledFilters.remove(at: a.row)
        }

        if b.section == 0 {
            enabledFilters.insert(targetItem, at: b.row)
        } else {
            disabledFilters.insert(targetItem, at: b.row)
        }

        // TEST only
        load()
    }

}

private extension FilterList.Controller {

    func load() {

        let test = FilterList.ViewState.Configuration(
            enabledFilters: enabledFilters,
            disabledFilters: disabledFilters,
            isEnabledInSettings: false
        )

        viewState.value = .loaded(test)
    }

}
