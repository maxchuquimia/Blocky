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

    private static let databaseName = "Filters.blocky"
    private let disk: DiskDataSourceInterface

    init(disk: DiskDataSourceInterface = DiskDataSource()) {
        self.disk = disk
    }

}

extension FilterDataSource: FilterDataSourceInterface {

    func readFilters() -> [Filter] {
        guard let data = disk.readData(named: FilterDataSource.databaseName) else { return [] }
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
            disk.write(data: data, named: FilterDataSource.databaseName)
        } catch {
            LogError("Unable to write filters because", error)
        }
    }

}
