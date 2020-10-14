//
//  BigButton.swift
//  Blocky
//
//  Created by Max Chuquimia on 11/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class BigButton: UIButton {

    let background: CardView = make {
        $0.isUserInteractionEnabled = false
    }

    let customTitle: UILabel = make {
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { die() }

    func setup() {
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter, .touchDragInside])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchDragExit, .touchDragOutside])

        insertSubview(background, at: 0)
        addSubview(customTitle)

        NSLayoutConstraint.activate(
            background.constraintsFillingSuperview(),
            customTitle.constraintsFillingSuperview()
        )

        NSLayoutConstraint.activate(
            heightAnchor.constraint(equalToConstant: 45)
        )
    }

    @objc func touchDown() {
        UIView.animate(withDuration: 0.2) {
            self.background.shadowLayer.shadowRadius = 0
            self.alpha = 0.9
        }
    }

    @objc func touchUp() {
        UIView.animate(withDuration: 0.2) {
            ViewStyle.Shadow.apply(to: self.background.shadowLayer)
            self.alpha = 1.0
        }
    }

}
