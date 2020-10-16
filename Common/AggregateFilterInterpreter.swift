//
//  AggregateFilterInterpreter.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

class AggregateFilterInterpreter {

    let dataSource: FilterDataSourceInterface

    init(dataSource: FilterDataSourceInterface = FilterDataSource()) {
        self.dataSource = dataSource
    }

    func isSpam(message: String) -> Bool {
        let filters = dataSource.readFilters()

        guard !filters.isEmpty else { return false }

        let interpreter = FilterInterpreter(suspiciousMessage: message)

        for filter in filters {
            if interpreter.isSpam(accordingTo: filter) {
                return true
            }
        }

        return false
    }
    
}
