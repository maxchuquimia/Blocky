//
//  OnboardingPage.swift
//  Blocky
//
//  Created by Max Chuquimia on 13/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class OnboardingPage: UIView {

    let titleLabel: UILabel = make {
        $0.textAlignment = .center
        $0.numberOfLines = 2
        ViewStyle.Label.PageTitle.apply(to: $0)
    }

    let contentLabel: UILabel = make {
        $0.numberOfLines = 0
        ViewStyle.Label.OnboardingContent.apply(to: $0)
    }

    let contentStack: UIStackView = make {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 20
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { die() }

    func setup() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(contentStack)
        contentStack.addArrangedSubview(contentLabel)

        NSLayoutConstraint.activate(
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CommonMetrics.margin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CommonMetrics.margin),

            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CommonMetrics.margin),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CommonMetrics.margin),
            contentStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        )
    }

    func addFlexibleSpace() {
        let guide: UIView = make {
            $0.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 0).isActive = true
            $0.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
        contentStack.addArrangedSubview(guide)
    }

}
