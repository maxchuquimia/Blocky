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

    let button: UIButton = make {
        ViewStyle.Button.Image.apply(to: $0, systemName: "plus")
        $0.contentMode = .bottom
    }

    var buttonAction: () -> () = { }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bind()
    }

    required init?(coder: NSCoder) { die() }

}

private extension FilterListHeaderView {

    func setup() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(button)

        NSLayoutConstraint.activate(
            titleLabel.constraintsFillingSuperview(insets: .init(top: 20, left: CommonMetrics.margin, bottom: 0, right: CommonMetrics.margin))
        )

        NSLayoutConstraint.activate(
            button.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CommonMetrics.margin),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
        )
    }

    func bind() {
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }

    @objc func buttonPressed() {
        buttonAction()
    }

}
