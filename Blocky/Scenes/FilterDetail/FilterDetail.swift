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

    enum ViewState {
        case new
        case editing(Filter)
    }

    enum EditingResult {
        case create(Filter)
        case overwrite(Filter)
        case delete(Filter)
    }

}

extension Filter.Rule.UnderlyingType: ListOption {

    var title: String {
        localisedName
    }

}
