//
//  FilterSummaryCell.swift
//  Blocky
//
//  Created by Max Chuquimia on 8/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class FilterSummaryCell: UITableViewCell {

    enum Metrics {
        static let margin: CGFloat = 8.0
        static let verticalSpacing: CGFloat = 4.0
        static let horizontalSpacing: CGFloat = 4.0
    }

    let card: CardView = make()

    let titleLabel: UILabel = make {
        ViewStyle.Label.CardHeader.apply(to: $0)
    }

    let verticalStack: UIStackView = make {
        $0.axis = .vertical
        $0.spacing = Metrics.verticalSpacing
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { die() }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        UIView.animate(withDuration: 0.2) {
            self.card.transform = highlighted ? .init(scaleX: 1.05, y: 1.05) : .init(scaleX: 1.0, y: 1.0)
        }
    }
}

extension FilterSummaryCell {

    func load(filter: Filter, isEnabled: Bool) {
        titleLabel.text = filter.name

        for view in verticalStack.arrangedSubviews {
            guard view != titleLabel else { continue }
            view.removeFromSuperview()
        }

        verticalStack.addArrangedSubview(
            genericTitleAndValue(Copy("Filter.Properties.Type"), filter.rule.localisedName)
        )

        verticalStack.addArrangedSubview(
            ruleTitleAndValue(for: filter.rule)
        )

        let localisedCaseSensitivity = filter.isCaseSensitive ? Copy("Rule.CaseSensitive.Yes") : Copy("Rule.CaseSensitive.No")
        verticalStack.addArrangedSubview(
            genericTitleAndValue(Copy("Filter.Properties.CaseSensitive"), localisedCaseSensitivity)
        )

        card.alpha = isEnabled ? 1.0 : 0.5
    }
    
}

private extension FilterSummaryCell {

    func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        addSubview(card)
        card.addSubview(verticalStack)
        verticalStack.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate(
            card.constraintsFillingSuperview(insets: .init(top: 10, left: CommonMetrics.margin, bottom: 10, right: CommonMetrics.margin)),
            verticalStack.constraintsFillingSuperview(insets: .init(top: Metrics.margin, left: Metrics.margin, bottom: Metrics.margin, right: Metrics.margin))
        )

    }

    func ruleTitleAndValue(for rule: Filter.Rule) -> UIView {
        var title: String = Copy("Filter.Properties.Value")
        var value: String = ""

        switch rule {
        case let .contains(substrings):
            if substrings.count > 1 {
                title = Copy("Filter.Properties.Value.Plural")
            }
           value = substrings.joined(separator: " & ")
        case let .exact(string):
            value = string
        case let .prefix(string):
            value = string
        case let .suffix(string):
            value = string
        case let .regex(expression):
            value = expression
        }

        return genericTitleAndValue(title, value)
    }

    func genericTitleAndValue(_ title: String, _ value: String) -> UIStackView {
        make {
            $0.axis = .horizontal
            $0.spacing =  Metrics.horizontalSpacing
            $0.addArrangedSubview(titleView(title))
            $0.addArrangedSubview(valueView(value))
        }
    }

    func titleView(_ name: String) -> UILabel {
        make {
            $0.text = name
            $0.widthAnchor.constraint(equalToConstant: 130).isActive = true
            ViewStyle.Label.CardProperty.Title.apply(to: $0)
        }
    }

    func valueView(_ value: String) -> UILabel {
        make {
            $0.text = value
            ViewStyle.Label.CardProperty.Value.apply(to: $0)
        }
    }

}
