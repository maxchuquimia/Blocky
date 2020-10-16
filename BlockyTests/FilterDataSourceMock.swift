//
//  FilterDataSourceMock.swift
//  BlockyTests
//
//  Created by Max Chuquimia on 16/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import XCTest
@testable import Blocky

class FilterDataSourceMock: FilterDataSourceInterface {

    var filters: [Filter] = []

    func readFilters() -> [Filter] {
        filters
    }

    func write(filters: [Filter]) {
        XCTFail("The mock should not recieve write events")
    }

}
