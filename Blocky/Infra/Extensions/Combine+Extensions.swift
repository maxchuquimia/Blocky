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
// Is a class because https://stackoverflow.com/questions/45415901/simultaneous-accesses-to-0x1c0a7f0f8-but-modification-requires-exclusive-access#comment92906161_46052743
class Variable<T: Equatable> {

    private var publisher = PassthroughSubject<T, Never>()

    var value: T {
        didSet {
            guard value != oldValue else { return }
            publisher.send(value)
        }
    }

    init(value: T) {
        self.value = value
    }

    func sink(reportImmediately: Bool = true, _ valueReport: @escaping (T) -> Void) -> AnyCancellable {
        if reportImmediately { valueReport(value) }
        return publisher.sink(receiveValue: valueReport)
    }

}
