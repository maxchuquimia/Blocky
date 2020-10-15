//
//  TestZoneView.swift
//  Blocky
//
//  Created by Max Chuquimia on 12/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

enum TestingState {
    case spam
    case notSpam
    case unknown
}

class TestZoneView: CardView {

    var state: TestingState = .unknown {
        didSet {
            switch state {
            case .spam:
                backgroundColor = Color.bud
            case .notSpam:
                backgroundColor = Color.carmine
            case .unknown:
                backgroundColor = Color.soaring
            }
        }
    }

    let statusMessage: UILabel = make {
        ViewStyle.Label.Footnote.apply(to: $0)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    let textField: CardValueTextView = make {
        ViewStyle.Field.TestZone.apply(to: $0)
        $0.accessibilityIdentifier = AI.FilterDetail.testZoneTextView
        $0.placeholderLabel.text = Copy("FilterDetail.TestZone.Placeholder")
    }

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) { die() }

    override func setup() {
        super.setup()
        backgroundColor = Color.soaring

        let title: UILabel = make {
            $0.text = Copy("FilterDetail.TestZone.Title")
            ViewStyle.Label.CardHeader.apply(to: $0)
        }

        let stack: UIStackView = make {
            $0.axis = .vertical
            $0.distribution = .fillProportionally
            $0.addArrangedSubview(title)
            $0.setCustomSpacing(5, after: title)
            $0.addArrangedSubview(textField)
            $0.setCustomSpacing(2, after: textField)
            $0.addArrangedSubview(statusMessage)
        }

        addSubview(stack)

        NSLayoutConstraint.activate(
            stack.constraintsFillingSuperview(insets: CommonMetrics.cardContentInset)
        )
    }

}
