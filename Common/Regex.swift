//
//  Regex.swift
//  Blocky
//
//  Created by Max Chuquimia on 11/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

class Regex {

    private(set) var expression: NSRegularExpression

    init(pattern: String, isCaseSensitive: Bool) throws {
        expression = try NSRegularExpression(pattern: pattern, options: isCaseSensitive ? [] : .caseInsensitive)
    }

    func matches(string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return expression.firstMatch(in: string, options: [], range: range) != nil
    }

}
