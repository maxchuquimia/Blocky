//
//  FilterListViewController.swift
//  Blocky
//
//  Created by Max Chuquimia on 15/9/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit
import Combine

extension FilterList {

    class ViewController: UIViewController {

        private enum TableSection: Int {
            case enabled = 0
            case disabled = 1
        }

        private let controller: FilterListController
        private var contentView: View { view as! View }

        private var currentConfiguration: FilterList.ViewState.Configuration = .init(
            enabledFilters: [],
            disabledFilters: [],
            isEnabledInSettings: true
        )

        private var cancellables: [AnyCancellable] = []

        init(controller: FilterListController = Controller()) {
            self.controller = controller
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) { die() }

        override func loadView() {
            view = View()
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            navigationItem.titleView = makeNavigationBarTitle("Blocky")
            bind()
        }

    }

}

private extension FilterList.ViewController {

    func bind() {
        controller.viewState
            .sink { [weak self] (nextState) in
                self?.render(state: nextState)
            }
            .store(in: &cancellables)

        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(FilterSummaryCell.self, forCellReuseIdentifier: "cell")
        contentView.tableView.register(FilterListHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
    }

    func render(state: FilterList.ViewState) {
        switch state {
        case let .loaded(configuration): render(configuration: configuration)
        }
    }

    func render(configuration: FilterList.ViewState.Configuration) {
        currentConfiguration = configuration
        contentView.tableView.reloadData()
    }

}

extension FilterList.ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection(rawValue: section) {
        case .enabled: return currentConfiguration.enabledFilters.count
        case .disabled: return currentConfiguration.disabledFilters.count
        default: die()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = TableSection(rawValue: indexPath.section)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterSummaryCell

        switch section {
        case .enabled:
            cell.load(filter: currentConfiguration.enabledFilters[indexPath.row], isEnabled: true)
        case .disabled:
            cell.load(filter: currentConfiguration.disabledFilters[indexPath.row], isEnabled: false)
        }

        cell.showsReorderControl = false

        return cell
    }

}

extension FilterList.ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! FilterListHeaderView
        switch TableSection(rawValue: section) {
        case .enabled:
            header.titleLabel.text = Copy("FilterList.Table.Enabled")
        case .disabled:
            header.titleLabel.text = Copy("FilterList.Table.Disabled")
        default: return nil
        }
        return header
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        controller.reorder(a: sourceIndexPath, to: destinationIndexPath)
    }

}
