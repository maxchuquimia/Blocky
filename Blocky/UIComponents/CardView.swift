//
//  CardView.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class CardView: UIView {

    let shadowLayer = CAShapeLayer()

    override var backgroundColor: UIColor? {
        didSet { setNeedsLayout() }
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { die() }

    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer.frame = bounds
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        shadowLayer.fillColor = backgroundColor?.cgColor
    }

    func setup() {
        layer.cornerRadius = 5.0
        backgroundColor = Color.white
        layer.addSublayer(shadowLayer)

        ViewStyle.Shadow.apply(to: shadowLayer)
    }

}
