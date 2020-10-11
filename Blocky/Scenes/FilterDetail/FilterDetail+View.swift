//
//  FilterDetail+View.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit
import Combine

extension FilterDetail {

    class View: UIView {

        let scrollingStack: UIStackView = make {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fillProportionally
            $0.spacing = 10
        }

        let contentCard: CardView = make()
        let titleField: CardTitleTextField = make()

        let filterTypeList = ListView<Filter.Rule.UnderlyingType>(
            options: [.contains, .prefix, .exact, .suffix, .regex],
            selectedOption: .contains
        )

        let cardStack: UIStackView = make {
            $0.axis = .vertical
            $0.spacing = 18.0
            $0.distribution = .fillProportionally
        }

        private var cancellables: [AnyCancellable] = []

        init() {
            super.init(frame: .zero)
            setup()
            bind()
        }

        required init?(coder: NSCoder) { die() }

    }

}

extension FilterDetail.View {

    func load(filter: Filter) {
        titleField.text = filter.name
        filterTypeList.select(item: filter.rule.underlyingType)

        // Skip the first two views (title and filter list)
        for view in cardStack.arrangedSubviews[2...] {
            view.removeFromSuperview()
        }

        switch filter.rule {
        case let .contains(substrings):
            addContainsFields(strings: substrings)
        case .exact(string: let value),
             .prefix(string: let value),
             .suffix(string: let value),
             .regex(expression: let value):
            addSingleField(rule: filter.rule, value: value)
        }
    }

    func addContainsFields(strings: [String]) {
        let value = CardValueTextView()
        value.placeholderLabel.text = Copy("Filter.Edit.Properties.Contains.Placeholder")
        value.text = strings.first ?? ""
        let section1 = makeCardSection(title: Copy("Filter.Edit.Properties.Contains.Title"), content: value)
        cardStack.addArrangedSubview(section1)

        let value2 = CardValueTextView()
        value2.placeholderLabel.text = Copy("Filter.Edit.Properties.Contains.Placeholder2")
        value2.text = strings.second ?? ""
        let section2 = makeCardSection(title: Copy("Filter.Edit.Properties.Contains.Title2"), content: value2)
        cardStack.addArrangedSubview(section2)
    }

    func addSingleField(rule: Filter.Rule, value: String) {
        let valueView = CardValueTextView()
        valueView.placeholderLabel.text = rule.valueFieldPlaceholder
        valueView.text = value
        let section = makeCardSection(title: rule.valueFieldTitle, content: valueView)
        cardStack.addArrangedSubview(section)
    }

}

private extension FilterDetail.View {

    func setup() {
        let scrollView: UIScrollView = make {
            $0.backgroundColor = Color.koamaru
        }

        let scrollViewContent: UIView = make {
            $0.backgroundColor = Color.koamaru
        }

        addSubview(scrollView)
        scrollView.addSubview(scrollViewContent)
        scrollViewContent.addSubview(scrollingStack)
        scrollingStack.addArrangedSubview(contentCard)
        contentCard.addSubview(cardStack)
        cardStack.addArrangedSubview(titleField)
        cardStack.addArrangedSubview(
            makeCardSection(title: Copy("Filter.Edit.Properties.Type"), content: filterTypeList)
        )

        NSLayoutConstraint.activate(
            scrollView.constraintsFillingSuperview(),
            scrollViewContent.constraintsFillingSuperview(),
            scrollingStack.constraintsFillingSuperview(insets: UIEdgeInsets(top: 0, left: CommonMetrics.margin, bottom: 0, right: CommonMetrics.margin)),
            cardStack.constraintsFillingSuperview(insets: CommonMetrics.cardContentInset)
        )

        NSLayoutConstraint.activate(
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        )
    }

    func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
        addGestureRecognizer(tap)
    }

    func makeCardSection(title: String, content: UIView) -> UIStackView {
        let result: UIStackView = make {
            $0.axis = .vertical
            $0.spacing = 0
        }

        let titleLabel: UILabel = make {
            $0.text = title
            ViewStyle.Label.CardProperty.Title.apply(to: $0)
            $0.textAlignment = .left
        }

        result.addArrangedSubview(titleLabel)
        result.addArrangedSubview(content)

        return result
    }

}

private extension Filter.Rule {

    var valueFieldTitle: String {
        switch self {
        case .contains: return Copy("Filter.Edit.Properties.Contains.Title")
        case .regex: return Copy("Filter.Edit.Properties.Regex.Title")
        case .prefix: return Copy("Filter.Edit.Properties.Prefix.Title")
        case .exact: return Copy("Filter.Edit.Properties.Exact.Title")
        case .suffix: return Copy("Filter.Edit.Properties.Suffix.Title")
        }
    }

    var valueFieldPlaceholder: String {
        switch self {
        case .contains: return Copy("Filter.Edit.Properties.Contains.Placeholder")
        case .regex: return Copy("Filter.Edit.Properties.Regex.Placeholder")
        case .prefix: return Copy("Filter.Edit.Properties.Prefix.Placeholder")
        case .exact: return Copy("Filter.Edit.Properties.Exact.Placeholder")
        case .suffix: return Copy("Filter.Edit.Properties.Suffix.Placeholder")
        }
    }

}
