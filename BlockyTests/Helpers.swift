//
//  Helpers.swift
//  BlockyTests
//
//  Created by Max Chuquimia on 16/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation
@testable import Blocky

extension Filter {

    static func make(with rule: Filter.Rule, isCaseSensitive: Bool) -> Filter {
        Filter(
            identifier: UUID(),
            name: "",
            rule: rule,
            isCaseSensitive: isCaseSensitive,
            order: 1
        )
    }

}
