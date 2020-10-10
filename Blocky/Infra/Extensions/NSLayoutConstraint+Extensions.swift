//
//  NSLayoutConstraint+Extensions.swift
//  Blocky
//
//  Created by Max Chuquimia on 9/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

extension UIView {

    func constraintsFillingSuperview(insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = self.superview else { die() }

        translatesAutoresizingMaskIntoConstraints = false

        return [
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left),
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
        ]
    }
    
}

extension NSLayoutConstraint {

    static func activate(_ constraints: NSLayoutConstraint...) {
        NSLayoutConstraint.activate(constraints)
    }

    static func activate(_ constraints: [NSLayoutConstraint]...) {
        NSLayoutConstraint.activate(constraints.flatMap({ $0 }))
    }

}
