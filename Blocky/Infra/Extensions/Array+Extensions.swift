//
//  Array+Extensions.swift
//  Blocky
//
//  Created by Max Chuquimia on 9/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

extension Array {

    static func += (lhs: inout [Element], rhs: Element) {
        lhs.append(rhs)
    }

    var second: Element? {
        guard count >= 2 else { return nil }
        return self[1]
    }

}
