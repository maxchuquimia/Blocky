//
//  FilterHelpCard.swift
//  Blocky
//
//  Created by Max Chuquimia on 13/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class FilterHelpDeck: PagingView {

    required init() {
        super.init(pages: [
            HelpCard(title: Filter.Rule.UnderlyingType.contains.localisedName, text: Copy("Filter.Help.Contains"), image: UIImage(named: "example-contains")!),
            HelpCard(title: Copy("Filter.Help.PrefixSuffix.Title"), text: Copy("Filter.Help.PrefixSuffix"), image: UIImage(named: "example-startswith")!),
            HelpCard(title: Filter.Rule.UnderlyingType.exact.localisedName, text: Copy("Filter.Help.ExactMatch"), image: UIImage(named: "example-exact")!),
            HelpCard(title: Filter.Rule.UnderlyingType.regex.localisedName, text: Copy("Filter.Help.Regex"), image: UIImage(named: "example-regex")!),
        ])
        setup()
    }

    required init?(coder: NSCoder) { die() }
    required init(pages: [UIView]) { die() }

    func setup() {
        closeButton.setImage(nil, for: .normal)
        nextPageButton.isHidden = true
        pageControl.currentPageIndicatorTintColor = nil
        pageControl.pageIndicatorTintColor = nil

        let helpDeckTitle: UILabel = make {
            $0.text = Copy("Filter.Help.Title")
            ViewStyle.Label.TableHeader.apply(to: $0)
        }

        addSubview(helpDeckTitle)

        NSLayoutConstraint.activate(
            helpDeckTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            helpDeckTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            helpDeckTitle.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -2),
            closeButton.heightAnchor.constraint(equalToConstant: 0),
            heightAnchor.constraint(equalToConstant: 250)
        )
    }

    override var keepsScrollViewAbovePageControl: Bool {
        true
    }

    override var bleed: CGFloat {
        CommonMetrics.margin
    }

}

private class HelpCard: UIView {

    init(title: String, text: String, image: UIImage) {
        super.init(frame: .zero)

        let title: UILabel = make {
            $0.text = title
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
            $0.setContentHuggingPriority(.required, for: .vertical)
            ViewStyle.Label.CardHeader.apply(to: $0)
        }

        let content: UILabel = make {
            $0.text = text
            $0.numberOfLines = 0
            ViewStyle.Label.RuleDescription.apply(to: $0)
        }

        let imageView: UIImageView = make {
            $0.image = image
            $0.contentMode = .scaleAspectFit
            $0.widthAnchor.constraint(equalToConstant: 150).isActive = true
        }

        let hstack: UIStackView = make {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 0
            $0.addArrangedSubview(imageView)
            $0.addArrangedSubview(content)
        }

        let vstack: UIStackView = make {
            $0.axis = .vertical
            $0.spacing = 5
            $0.distribution = .fill
            $0.addArrangedSubview(title)
            $0.addArrangedSubview(hstack)
        }

        let card: CardView = make()

        card.addSubview(vstack)
        addSubview(card)

        NSLayoutConstraint.activate(
            card.constraintsFillingSuperview(insets: .init(top: 0, left: CommonMetrics.margin, bottom: 0, right: CommonMetrics.margin)),
            vstack.constraintsFillingSuperview(insets: .init(top: CommonMetrics.cardContentInset.top, left: 0, bottom: CommonMetrics.cardContentInset.bottom, right: CommonMetrics.cardContentInset.right))
        )

    }

    required init?(coder: NSCoder) { die() }
    
}
