//
//  FilterDetail+View.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

extension FilterDetail {

    class View: UIView {

        let scrollingStack: UIStackView = make {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fillProportionally
            $0.spacing = 10
        }

        let contentCard: CardView = make()
        let titleField: UITextField = make {
            $0.placeholder = "test"
        }
        let filterTypeList = ListView<Filter.Rule.UnderlyingType>(
            options: [.contains, .prefix, .exact, .suffix, .regex],
            selectedOption: .contains
        )

        let cardStack: UIStackView = make {
            $0.axis = .vertical
            $0.spacing = 18.0
            $0.distribution = .fillProportionally
        }

        init() {
            super.init(frame: .zero)
            setup()
        }

        required init?(coder: NSCoder) { die() }

    }

}

extension FilterDetail.View {

    func load(filter: Filter) {
        // Skip the first two views (title and filter list)
        for view in cardStack.arrangedSubviews[2...] {
            view.removeFromSuperview()
        }

        switch filter.rule {
        case let .contains(substrings):
            break
        case .exact(string: let value), .prefix(string: let value), .suffix(string: let value), .regex(expression: let value):
            break
        }


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

    func makeCardSection(title: String, content: UIView) -> UIStackView {
        let result: UIStackView = make {
            $0.axis = .vertical
            $0.spacing = 6.0
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
