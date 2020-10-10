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
            collectionView.backgroundColor = Color.koamaru
            collectionView.dragInteractionEnabled = true
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
        backgroundColor = Color.koamaru
        addSubview(collectionView)

        NSLayoutConstraint.activate(
            collectionView.constraintsFillingSuperview()
        )
    }

}
