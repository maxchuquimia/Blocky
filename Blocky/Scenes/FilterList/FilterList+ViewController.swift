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

    class ViewController: BaseViewController {

        private enum TableSection: Int, CaseIterable {
            case enabled = 0
        }

        private let controller: FilterListController
        private var contentView: View { view as! View }
        private var cancellables: [AnyCancellable] = []

        private var currentConfiguration: FilterList.ViewState.Configuration = .init(
            allFilters: [],
            isEnabledInSettings: false
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

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            if !UserDefaults.standard.bool(forKey: "didShowOnboarding") {
                UserDefaults.standard.setValue(true, forKey: "didShowOnboarding")
                let vc = OnboardingViewController()
                present(vc, animated: true, completion: nil)
            }
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

        let tap = UITapGestureRecognizer(target: self, action: #selector(bannerTapped))
        contentView.lowerBanner.addGestureRecognizer(tap)

        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
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

    @objc func bannerTapped() {
        let vc = OnboardingViewController()
        present(vc, animated: true, completion: { [weak vc] in vc?.scrollToLastPage() })
    }

}

extension FilterList.ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        TableSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch TableSection(rawValue: section) {
        case .enabled: return currentConfiguration.allFilters.count
        default: die()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = TableSection(rawValue: indexPath.section)!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilterSummaryCell

        switch section {
        case .enabled:
            cell.load(filter: currentConfiguration.allFilters[indexPath.row], isEnabled: true)
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
            filter = currentConfiguration.allFilters[indexPath.row]
        }

        showEditor(for: .editing(filter))
    }

}
