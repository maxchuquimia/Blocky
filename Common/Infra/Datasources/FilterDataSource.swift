//
//  FilterDataSource.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

protocol FilterDataSourceInterface {
    func readFilters() -> [Filter]
    func write(filters: [Filter])
}

class FilterDataSource {

    private let databaseName = "Filters.blocky"
    private let disk: DiskDataSourceInterface

    init(disk: DiskDataSourceInterface = DiskDataSource()) {
        self.disk = disk

//        let test = [
//            Filter(identifier: UUID(), name: "Some filter", rule: .exact(string: "This is a SPAM text message so yeah"), isCaseSensitive: false, isEnabled: true, order: 1),
//            Filter(identifier: UUID(), name: "Another filter", rule: .prefix(string: "Final Notice:"), isCaseSensitive: false, isEnabled: true, order: 2),
//            Filter(identifier: UUID(), name: "Even more filter", rule: .regex(expression: ".*http.*"), isCaseSensitive: true, isEnabled: true, order: 3),
//            Filter(identifier: UUID(), name: "This one is disabled", rule: .exact(string: "test"), isCaseSensitive: false, isEnabled: false, order: 1),
//        ]
//
//        write(filters: test)
    }

}

extension FilterDataSource: FilterDataSourceInterface {

    func readFilters() -> [Filter] {
        guard let data = disk.readData(named: databaseName) else { return [] }
        do {
            return try JSONDecoder().decode([Filter].self, from: data)
        } catch {
            LogError("Unable to read filters because", error)
            return []
        }
    }

    func write(filters: [Filter]) {
        do {
            let data = try JSONEncoder().encode(filters)
            disk.write(data: data, named: databaseName)
        } catch {
            LogError("Unable to write filters because", error)
        }
    }

}
