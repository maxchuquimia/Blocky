//
//  AggregateFilterInterpreterTests.swift
//  BlockyTests
//
//  Created by Max Chuquimia on 16/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import XCTest
@testable import Blocky

class AggregateFilterInterpreterTests: XCTestCase {

    var sut: AggregateFilterInterpreter!
    var dataSourceMock: FilterDataSourceMock!
    let message = "Final Notice: If submission is not received by 5pm you will forfeit your requested amount-and-transfer preferences: http://rrvfl.xyz/y2hrem"

    override func setUpWithError() throws {
        dataSourceMock = FilterDataSourceMock()
        sut = AggregateFilterInterpreter(dataSource: dataSourceMock)
    }

    func testReportsNotSpamWhenNoFiltersAreSaved() {
        dataSourceMock.filters = []
        XCTAssertFalse(sut.isSpam(message: message))
    }

    func testReportsNotSpamWhenNoMatchesOccur() {
        dataSourceMock.filters = [
            .make(with: .contains(substrings: ["test"]), isCaseSensitive: false),
            .make(with: .prefix(string: "Notice"), isCaseSensitive: true),
        ]

        XCTAssertFalse(sut.isSpam(message: message))
    }

    func testReportsSpamWhenOneMatchOccurs() {
        dataSourceMock.filters = [
            .make(with: .contains(substrings: ["5pm"]), isCaseSensitive: false),
            .make(with: .suffix(string: "Notice"), isCaseSensitive: true),
        ]

        XCTAssertTrue(sut.isSpam(message: message))
    }

    func testReportsSpamWhenTwoMatchesOccurs() {
        dataSourceMock.filters = [
            .make(with: .contains(substrings: ["5PM", "test"]), isCaseSensitive: false),
            .make(with: .suffix(string: "http://rrvfl.xyz/y2hrem"), isCaseSensitive: true),
        ]

        XCTAssertTrue(sut.isSpam(message: message))
    }

}
