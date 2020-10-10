//
//  Filter.swift
//  Blocky
//
//  Created by Max Chuquimia on 8/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

struct Filter {

    enum Rule {
        case contains(substrings: [String])
        case regex(expression: String)
        case prefix(string: String)
        case exact(string: String)
        case suffix(string: String)
    }

    let name: String
    let rule: Rule
    let isCaseSensitive: Bool

}

extension Filter.Rule {

    var localisedName: String {
        switch self {
        case .contains: return Copy("Rule.Contains.Name")
        case .regex: return Copy("Rule.Regex.Name")
        case .prefix: return Copy("Rule.Prefix.Name")
        case .exact: return Copy("Rule.Exact.Name")
        case .suffix: return Copy("Rule.Suffix.Name")
        }
    }

}
