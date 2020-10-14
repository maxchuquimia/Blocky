//
//  FilterDetail.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

enum FilterDetail {

}

extension FilterDetail {

    enum ViewState: Equatable {
        case new
        case editing(Filter)
    }

    enum EditingResult {
        case create(Filter)
        case overwrite(Filter)
        case delete(Filter)
    }

    enum ValidationError: LocalizedError {
        case invalidRegex(message: String)
        case emptyValue

        var errorDescription: String? {
            switch self {
            case let .invalidRegex(message): return message
            case .emptyValue: return Copy("FilterDetail.Error.EmptyValue")
            }
        }
    }
}

extension Filter.Rule.UnderlyingType: ListOption {

    var title: String {
        localisedName
    }

}
