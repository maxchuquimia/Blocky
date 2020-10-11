//
//  Filter.swift
//  Blocky
//
//  Created by Max Chuquimia on 8/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

struct Filter: Codable {

    enum Rule {
        case contains(substrings: [String])
        case regex(expression: String)
        case prefix(string: String)
        case exact(string: String)
        case suffix(string: String)
    }

    let identifier: UUID
    let name: String
    let rule: Rule
    let isCaseSensitive: Bool
    let isEnabled: Bool
    let order: Int

}

extension Filter {

    static func new(with type: Filter.Rule.UnderlyingType) -> Filter {
        switch type {
        case.contains: return new(with: .contains(substrings: [""]))
        case.regex: return new(with: .regex(expression: ""))
        case.prefix: return new(with: .prefix(string: ""))
        case.exact: return new(with: .exact(string: ""))
        case.suffix: return new(with: .suffix(string: ""))
        }
    }

    private static func new(with rule: Filter.Rule) -> Filter {
        Filter(identifier: UUID(), name: "", rule: rule, isCaseSensitive: false, isEnabled: true, order: -1)
    }

}

extension Filter.Rule: Codable {

    enum UnderlyingType: String, Codable {
        case contains = "Rule.Contains"
        case regex = "Rule.Regex"
        case prefix = "Rule.Prefix"
        case exact = "Rule.Exact"
        case suffix = "Rule.Suffix"
    }

    var underlyingType: UnderlyingType {
        switch self {
        case .contains: return .contains
        case .regex: return .regex
        case .prefix: return .prefix
        case .exact: return .exact
        case .suffix: return .suffix
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(UnderlyingType.self, forKey: .type)

        switch type {
        case .contains:
            let substrings = try container.decode([String].self, forKey: .valueList)
            self = .contains(substrings: substrings)
        case .regex:
            let value = try container.decode(String.self, forKey: .singleValue)
            self = .regex(expression: value)
        case .prefix:
            let value = try container.decode(String.self, forKey: .singleValue)
            self = .prefix(string: value)
        case .exact:
            let value = try container.decode(String.self, forKey: .singleValue)
            self = .exact(string: value)
        case .suffix:
            let value = try container.decode(String.self, forKey: .singleValue)
            self = .suffix(string: value)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(underlyingType, forKey: .type)
        switch self {
        case let .contains(list):
            try container.encode(list, forKey: .valueList)
        case let .regex(expression):
            try container.encode(expression, forKey: .singleValue)
        case let .prefix(string):
            try container.encode(string, forKey: .singleValue)
        case let .exact(string):
            try container.encode(string, forKey: .singleValue)
        case let .suffix(string):
            try container.encode(string, forKey: .singleValue)
        }
    }

    enum CodingKeys: CodingKey {
      case type, valueList, singleValue
    }

}

extension Filter.Rule {

    var localisedName: String { underlyingType.localisedName }
    
}

extension Filter.Rule.UnderlyingType {

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
