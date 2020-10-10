//
//  FilterInterpreter.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

struct FilterInterpreter {

    let suspiciousMessage: String

    init(suspiciousMessage: String) {
        self.suspiciousMessage = suspiciousMessage
    }

    /// Checks if `suspiciousMessage` is spam
    /// - Parameter filter: the filter to perform
    /// - Returns: `true` when the message IS spam
    func isSpam(accordingTo filter: Filter) -> Bool {
        let message = filter.transform(suspiciousMessage)

        switch filter.rule {
        case let .contains(substrings):
            var matches = 0
            for substring in substrings {
                if message.contains(filter.transform(substring)) {
                    matches += 1
                }
            }
            // If all matches are found, then this message is spam
            return matches == substrings.count
        case let .regex(expression):
            die()
        case let .prefix(string):
            let string = filter.transform(string)
            return message.hasPrefix(string)
        case let .exact(string):
            let string = filter.transform(string)
            return message == string
        case let .suffix(string):
            let string = filter.transform(string)
            return message.hasSuffix(string)
        }
    }

}

private extension Filter {

    func transform(_ string: String) -> String {
        if isCaseSensitive {
            return string
        } else {
            return string.lowercased()
        }
    }

}
