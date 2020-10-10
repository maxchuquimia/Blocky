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

        let tableView: UITableView = make {
            $0.separatorStyle = .none
            $0.backgroundColor = Color.koamaru
            $0.isEditing = true
        }

        init() {
            super.init(frame: .zero)
            setup()
        }

        required init?(coder: NSCoder) { die() }

    }
    
}

private extension FilterList.View {

    func setup() {
        backgroundColor = Color.koamaru
        addSubview(tableView)

        NSLayoutConstraint.activate(
            tableView.constraintsFillingSuperview()
        )
    }

}
