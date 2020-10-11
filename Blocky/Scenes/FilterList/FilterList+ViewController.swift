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
        private var cancellables: [AnyCancellable] = []

        private var currentConfiguration: FilterList.ViewState.Configuration = .init(
            enabledFilters: [],
            disabledFilters: [],
            isEnabledInSettings: true
        )


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
            navigationItem.titleView = makeNavigationBarTitle(Copy("FilterList.Title"))
            bind()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            contentView.collectionView.collectionViewLayout.invalidateLayout()
            contentView.layoutIfNeeded()
        }

        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            coordinator.animate(alongsideTransition: { context in
                self.contentView.collectionView.collectionViewLayout.invalidateLayout()
            }, completion: nil)
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

        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        contentView.collectionView.dragDelegate = self
        contentView.collectionView.dropDelegate = self
        contentView.collectionView.register(FilterSummaryCell.self, forCellWithReuseIdentifier: "cell")
        contentView.collectionView.register(FilterListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }

    func render(state: FilterList.ViewState) {
        switch state {
        case let .loaded(configuration): render(configuration: configuration)
        }
    }

    func render(configuration: FilterList.ViewState.Configuration) {
        currentConfiguration = configuration
        contentView.collectionView.reloadData()
    }

    func showEditor(for state: FilterDetail.ViewState) {
        let editor = FilterDetail.ViewController(
            controller: FilterDetail.Controller(
                state: state,
                result: { [weak self] result in
                    switch result {
                    case let .delete(filter): self?.controller.delete(filter: filter)
                    case let .create(filter), let .overwrite(filter): self?.controller.save(filter: filter)
                    }

                    self?.navigationController?.popViewController(animated: true)
                }
            )
        )

        show(editor, sender: self)
    }

}

extension FilterList.ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch TableSection(rawValue: section) {
        case .enabled: return currentConfiguration.enabledFilters.count
        case .disabled: return currentConfiguration.disabledFilters.count
        default: die()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = TableSection(rawValue: indexPath.section)!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilterSummaryCell

        switch section {
        case .enabled:
            cell.load(filter: currentConfiguration.enabledFilters[indexPath.row], isEnabled: true)
        case .disabled:
            cell.load(filter: currentConfiguration.disabledFilters[indexPath.row], isEnabled: false)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! FilterListHeaderView

        switch TableSection(rawValue: indexPath.section) {
        case .enabled:
            header.titleLabel.text = Copy("FilterList.Table.Enabled")
            header.button.isHidden = false
            header.buttonAction = { [weak self] in
                self?.showEditor(for: .new)
            }
        case .disabled:
            header.titleLabel.text = Copy("FilterList.Table.Disabled")
            header.button.isHidden = true
        default: return UICollectionReusableView()
        }

        return header
    }

}

extension FilterList.ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = TableSection(rawValue: indexPath.section)!
        let filter: Filter
        switch section {
        case .enabled:
            filter = currentConfiguration.enabledFilters[indexPath.row]
        case .disabled:
            filter = currentConfiguration.disabledFilters[indexPath.row]
        }

        showEditor(for: .editing(filter))
    }

}

extension FilterList.ViewController: UICollectionViewDragDelegate {

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let section = TableSection(rawValue: indexPath.section)!
        let filter: Filter
        switch section {
        case .enabled:
            filter = currentConfiguration.enabledFilters[indexPath.row]
        case .disabled:
            filter = currentConfiguration.disabledFilters[indexPath.row]
        }

        let provider = NSItemProvider(object: String(describing: filter) as NSString)
        let drag = UIDragItem(itemProvider: provider)
        drag.localObject = filter
        return [drag]
    }

}

extension FilterList.ViewController: UICollectionViewDropDelegate {
    // https://github.com/Maxnelson997/DragAndDropUICollectionViewCells/blob/master/dragdropsection/ViewController.swift

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath

        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }

        if coordinator.proposal.operation == .move {
           reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }

    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath:IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                self.controller.reorder(a: sourceIndexPath, to: destinationIndexPath)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }

}
