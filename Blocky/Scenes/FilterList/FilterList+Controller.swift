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
    func save(filter: Filter)
    func delete(filter: Filter)
}

extension FilterList {

    class Controller: FilterListController {

        internal var viewState: Variable<ViewState> = .init(value: .initial)

        private var allFilters: [Filter] = []
        private let filterDataSource: FilterDataSourceInterface

        init(filterDataSource: FilterDataSourceInterface = FilterDataSource()) {
            self.filterDataSource = filterDataSource

            presentFilters()
        }

    }

}

extension FilterList.Controller {

    func save(filter: Filter) {
        var allFilters = filterDataSource.readFilters()

        // Replace existing filter if possible
        if let idx = allFilters.firstIndex(where: { $0.identifier == filter.identifier }) {
            allFilters[idx] = filter
        } else {
            allFilters.append(filter)
        }

        filterDataSource.write(filters: allFilters)

        presentFilters()
    }

    func delete(filter: Filter) {
        var allFilters = filterDataSource.readFilters()
        allFilters.removeAll(where: { $0.identifier == filter.identifier })

        filterDataSource.write(filters: allFilters)

        presentFilters()
    }

}

private extension FilterList.Controller {

    func readFilters() {
        allFilters = filterDataSource.readFilters().sorted(by: { $0.order > $1.order })
    }

    func storeFilters() {
        filterDataSource.write(filters: allFilters)
    }

    func presentFilters() {
        readFilters()

        let viewConfiguration = FilterList.ViewState.Configuration(
            allFilters: allFilters,
            isEnabledInSettings: false
        )

        viewState.value = .loaded(viewConfiguration)
    }

}
