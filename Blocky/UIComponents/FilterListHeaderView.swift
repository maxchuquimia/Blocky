//
//  FilterListHeaderView.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class FilterListHeaderView: UITableViewHeaderFooterView {

    let titleLabel: UILabel = make {
        ViewStyle.Label.TableHeader.apply(to: $0)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { die() }

}

private extension FilterListHeaderView {

    func setup() {
        backgroundView = UIView()
        backgroundView?.backgroundColor = Color.koamaru
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate(
            titleLabel.constraintsFillingSuperview(insets: .init(top: 20, left: CommonMetrics.margin, bottom: 0, right: CommonMetrics.margin))
        )
    }

}
