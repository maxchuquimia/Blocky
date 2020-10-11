//
//  Make.swift
//  Blocky
//
//  Created by Max Chuquimia on 8/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

func make<T>(_ setup: ((T) -> Void) = { _ in }) -> T where T: NSObject {
    let obj = T()
    setup(obj)
    return obj
}


import UIKit

func make<T>(_ setup: ((T) -> Void) = { _ in }) -> T where T: UIView {
    let view: T

    if T.self == UIButton.self {
        view = UIButton(type: .system) as! T
    } else {
        view = T()
    }

    view.translatesAutoresizingMaskIntoConstraints = false
    setup(view)

    if let label = view as? UILabel {
        label.adjustsFontForContentSizeCategory = true
    }

    return view
}

func make<L, T>(layout: L, _ setup: ((T, L) -> Void) = { _, _ in }) -> T where T: UICollectionView, L: UICollectionViewLayout {
    let view = T(frame: .zero, collectionViewLayout: layout)
    view.translatesAutoresizingMaskIntoConstraints = false
    setup(view, layout)
    return view
}

