//
//  Combine+Extensions.swift
//  Blocky
//
//  Created by Max Chuquimia on 8/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation
import Combine

// Not a property wrapper so that we can expose it through a protocol nicely
struct Variable<T> {

    private var publisher = PassthroughSubject<T, Never>()

    var value: T {
        didSet {
            publisher.send(value)
        }
    }

    init(value: T) {
        self.value = value
    }

    func sink(_ valueReport: @escaping (T) -> Void) -> AnyCancellable {
        valueReport(value)
        return publisher.sink(receiveValue: valueReport)
    }

}
