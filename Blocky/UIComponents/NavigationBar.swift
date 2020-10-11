//
//  NavigationBar.swift
//  Blocky
//
//  Created by Max Chuquimia on 9/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { die() }

}

private extension NavigationBar {

    func setup() {
        backgroundColor = Color.koamaru
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
        tintColor = Color.ice

        let safeAreaCover: UIView = make {
            $0.backgroundColor = Color.koamaru
        }

        insertSubview(safeAreaCover, at: 0)

        NSLayoutConstraint.activate(
            safeAreaCover.bottomAnchor.constraint(equalTo: topAnchor),
            safeAreaCover.leadingAnchor.constraint(equalTo: leadingAnchor),
            safeAreaCover.trailingAnchor.constraint(equalTo: trailingAnchor),
            safeAreaCover.heightAnchor.constraint(equalToConstant: 60.0)
        )
    }

}

func makeNavigationBarTitle(_ text: String) -> UIView {
    let label: UILabel = make {
        ViewStyle.Label.PageTitle.apply(to: $0)
    }
    label.text = text
    return label
}
