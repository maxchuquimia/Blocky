//
//  FilterListHeaderView.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class FilterListHeaderView: UICollectionReusableView {

    let titleLabel: UILabel = make {
        ViewStyle.Label.TableHeader.apply(to: $0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { die() }

}

private extension FilterListHeaderView {

    func setup() {
        backgroundColor = Color.koamaru
        addSubview(titleLabel)

        NSLayoutConstraint.activate(
            titleLabel.constraintsFillingSuperview(insets: .init(top: 20, left: CommonMetrics.margin, bottom: 0, right: CommonMetrics.margin))
        )
    }

}
