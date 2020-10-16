//
//  BlockyTests.swift
//  BlockyTests
//
//  Created by Max Chuquimia on 16/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import XCTest
@testable import Blocky

class FilterInterpreterTests: XCTestCase {

    var sut: FilterInterpreter!
    let message = "Final Notice: If submission is not received by 5pm you will forfeit your requested amount-and-transfer preferences: http://rrvfl.xyz/y2hrem"

    override func setUpWithError() throws {
        sut = FilterInterpreter(suspiciousMessage: message)
    }

    // MARK: Prefix

    func testPrefixFilterSucceeds() {
        let filter = Filter.make(with: .prefix(string: "final notice"), isCaseSensitive: false)
        XCTAssertTrue(sut.isSpam(accordingTo: filter))
    }

    func testCaseSensitivePrefixFilterSucceeds() {
        let filter = Filter.make(with: .prefix(string: "Final Notice"), isCaseSensitive: true)
        XCTAssertTrue(sut.isSpam(accordingTo: filter))
    }

    func testPrefixFilterFails() {
        let filter = Filter.make(with: .prefix(string: "notice"), isCaseSensitive: false)
        XCTAssertFalse(sut.isSpam(accordingTo: filter))
    }

    func testCaseSensitivePrefixFilterFails() {
        let filter = Filter.make(with: .prefix(string: "final notice"), isCaseSensitive: true)
        XCTAssertFalse(sut.isSpam(accordingTo: filter))
    }

    // MARK: Suffix

    func testSuffixFilterSucceeds() {
        let filter = Filter.make(with: .suffix(string: "Y2hreM"), isCaseSensitive: false)
        XCTAssertTrue(sut.isSpam(accordingTo: filter))
    }

    func testCaseSensitiveSuffixFilterSucceeds() {
        let filter = Filter.make(with: .suffix(string: "y2hrem"), isCaseSensitive: true)
        XCTAssertTrue(sut.isSpam(accordingTo: filter))
    }

    func testSuffixFilterFails() {
        let filter = Filter.make(with: .suffix(string: "STOP"), isCaseSensitive: false)
        XCTAssertFalse(sut.isSpam(accordingTo: filter))
    }

    func testCaseSensitiveSuffixFilterFails() {
        let filter = Filter.make(with: .suffix(string: "Y2hreM"), isCaseSensitive: true)
        XCTAssertFalse(sut.isSpam(accordingTo: filter))
    }

    // MARK: Exact

    func testExactFilterSucceeds() {
        let filter = Filter.make(with: .exact(string: message.lowercased()), isCaseSensitive: false)
        XCTAssertTrue(sut.isSpam(accordingTo: filter))
    }

    func testCaseSensitiveExactFilterSucceeds() {
        let filter = Filter.make(with: .exact(string: message), isCaseSensitive: true)
        XCTAssertTrue(sut.isSpam(accordingTo: filter))
    }

    func testExactFilterFails() {
        let filter = Filter.make(with: .exact(string: message + "!"), isCaseSensitive: false)
        XCTAssertFalse(sut.isSpam(accordingTo: filter))
    }

    func testCaseSensitiveExactFilterFails() {
        let filter = Filter.make(with: .exact(string: message.uppercased()), isCaseSensitive: true)
        XCTAssertFalse(sut.isSpam(accordingTo: filter))
    }

    // MARK: Regex

    func testRegexFilterSucceeds() {
        let filter1 = Filter.make(with: .regex(expression: "^final notice"), isCaseSensitive: false)
        XCTAssertTrue(sut.isSpam(accordingTo: filter1))

        let filter2 = Filter.make(with: .regex(expression: "(HTTP|HTTPS).*\\.xyz"), isCaseSensitive: false)
        XCTAssertTrue(sut.isSpam(accordingTo: filter2))
    }

    func testCaseSensitiveRegexFilterSucceeds() {
        let filter = Filter.make(with: .regex(expression: "^Final Notice"), isCaseSensitive: true)
        XCTAssertTrue(sut.isSpam(accordingTo: filter))

        let filter2 = Filter.make(with: .regex(expression: "(http|https).*\\.xyz"), isCaseSensitive: true)
        XCTAssertTrue(sut.isSpam(accordingTo: filter2))
    }

    func testRegexFilterFails() {
        let filter = Filter.make(with: .regex(expression: "Final Notice$"), isCaseSensitive: false)
        XCTAssertFalse(sut.isSpam(accordingTo: filter))

        let filter2 = Filter.make(with: .regex(expression: "(httd|https).*\\.com"), isCaseSensitive: false)
        XCTAssertFalse(sut.isSpam(accordingTo: filter2))
    }

    func testCaseSensitiveRegexFilterFails() {
        let filter = Filter.make(with: .regex(expression: "^final notice"), isCaseSensitive: true)
        XCTAssertFalse(sut.isSpam(accordingTo: filter))

        let filter2 = Filter.make(with: .regex(expression: "(HTTP|HTTPS).*\\.xyz"), isCaseSensitive: true)
        XCTAssertFalse(sut.isSpam(accordingTo: filter2))
    }

    // MARK: Contains

    func testContainsFilterSucceeds() {
        let filter1 = Filter.make(with: .contains(substrings: ["notice"]), isCaseSensitive: false)
        XCTAssertTrue(sut.isSpam(accordingTo: filter1))

        let filter2 = Filter.make(with: .contains(substrings: ["5pm", "final"]), isCaseSensitive: false)
        XCTAssertTrue(sut.isSpam(accordingTo: filter2))
    }

    func testCaseSensitiveContainsFilterSucceeds() {
        let filter1 = Filter.make(with: .contains(substrings: ["Notice"]), isCaseSensitive: true)
        XCTAssertTrue(sut.isSpam(accordingTo: filter1))

        let filter2 = Filter.make(with: .contains(substrings: ["submission is not received", "Notice"]), isCaseSensitive: true)
        XCTAssertTrue(sut.isSpam(accordingTo: filter2))
    }

    func testContainsFilterFails() {
        let filter1 = Filter.make(with: .contains(substrings: ["I swear this is not spam"]), isCaseSensitive: false)
        XCTAssertFalse(sut.isSpam(accordingTo: filter1))

        let filter2 = Filter.make(with: .contains(substrings: ["hello there", "Final Notice"]), isCaseSensitive: false)
        XCTAssertFalse(sut.isSpam(accordingTo: filter2))
    }

    func testCaseSensitiveContainsFilterFails() {
        let filter1 = Filter.make(with: .contains(substrings: ["notice"]), isCaseSensitive: true)
        XCTAssertFalse(sut.isSpam(accordingTo: filter1))

        let filter2 = Filter.make(with: .contains(substrings: ["5pm", "0x0000"]), isCaseSensitive: true)
        XCTAssertFalse(sut.isSpam(accordingTo: filter2))
    }

}
