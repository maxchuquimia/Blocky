//
//  Persistence.swift
//  Blocky
//
//  Created by Max Chuquimia on 14/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

struct Persistence {

    static var didWriteExampleFilters: Storable<Bool> = "Blocky.didWriteExampleFilters"
    static var didShowOnboarding: Storable<Bool> = "Blocky.didShowOnboarding"

}

// MARK: Compatible Types

extension Bool: StoredAsSelf {
    typealias Primitive = Bool
}

// MARK: Storables

protocol StoredObject {
    associatedtype Primitive
    func toPrimitive() -> Primitive?
    static func from(primitive: Primitive) -> Self?
}

protocol StoredAsSelf: StoredObject where Primitive == Self { }

extension StoredAsSelf {

    func toPrimitive() -> Primitive? {
        return self
    }

    static func from(primitive: Primitive) -> Primitive? {
        return primitive
    }
}

protocol StringLiteralBoilerplate {
    init(stringLiteral value: String)
}

extension StringLiteralBoilerplate {
    typealias StringLiteralType = String

    init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }

    init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

struct Storable<Object>: ExpressibleByStringLiteral, StringLiteralBoilerplate where Object: StoredObject {

    private let key: String
    private let store = UserDefaults.standard

    init(stringLiteral value: String) {
        self.key = value
    }

    var value: Object? {
        set {
            store.set(newValue?.toPrimitive(), forKey: key)
        }
        get {
            guard let p = store.value(forKey: key) as? Object.Primitive else { return nil }
            return Object.from(primitive: p)
        }
    }
}
