//
//  FilterListView.swift
//  Blocky
//
//  Created by Max Chuquimia on 8/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

extension FilterList {

    class View: UIView {

        let collectionView: UICollectionView = make(layout: View.makeLayout()) { collectionView, _ in
            collectionView.backgroundColor = UIColor.clear
        }

        let lowerBanner: UIView = make {
            $0.backgroundColor = Color.soaring
            let label: UILabel = make {
                ViewStyle.Label.Banner.apply(to: $0)
                $0.text = Copy("FilterList.Banner.Message")
            }
            let button: UIButton = make {
                $0.setImage(UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
                $0.contentMode = .bottom
                $0.tintColor = Color.ice
                $0.isUserInteractionEnabled = false
                $0.accessibilityTraits = .notEnabled
            }

            $0.accessibilityTraits = .button

            $0.addSubview(label)
            $0.addSubview(button)

            NSLayoutConstraint.activate(
                label.leadingAnchor.constraint(equalTo: $0.leadingAnchor, constant: CommonMetrics.margin),
                label.topAnchor.constraint(equalTo: $0.topAnchor),
                label.bottomAnchor.constraint(equalTo: $0.bottomAnchor),

                button.trailingAnchor.constraint(equalTo: $0.trailingAnchor, constant: -CommonMetrics.margin),
                button.centerYAnchor.constraint(equalTo: $0.centerYAnchor)
            )
        }

        init() {
            super.init(frame: .zero)
            setup()
        }

        required init?(coder: NSCoder) { die() }

    }
    
}

private extension FilterList.View {

    static func makeLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(96)
        )

        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .zero
        section.interGroupSpacing = .zero

        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: "SectionHeaderElementKind",
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]

        return UICollectionViewCompositionalLayout(section: section)
    }

    func setup() {
        addSubview(collectionView)
        addSubview(lowerBanner)

        NSLayoutConstraint.activate(
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: lowerBanner.topAnchor),

            lowerBanner.leadingAnchor.constraint(equalTo: leadingAnchor),
            lowerBanner.trailingAnchor.constraint(equalTo: trailingAnchor),
            lowerBanner.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            lowerBanner.heightAnchor.constraint(equalToConstant: 60)
        )
    }

}
