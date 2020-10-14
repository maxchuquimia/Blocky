//
//  FilterDetail+ViewController.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit
import Combine

extension FilterDetail {

    class ViewController: BaseViewController {

        private let controller: FilterDetailController
        private var contentView: View { view as! View }
        private var cancellables: [AnyCancellable] = []

        /// The filter that was initially loaded into the view.
        /// This property can be used to restore changes - i.e. it is out of date
        private(set) var loadedFilter: Filter?

        init(controller: FilterDetailController) {
            self.controller = controller
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) { die() }

        override func loadView() {
            view = View()
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            bind()
        }

    }

}

private extension FilterDetail.ViewController {

    func bind() {
        contentView.saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        contentView.deleteButton.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)

        controller.viewState
            .sink { [weak self] (nextState) in
                self?.render(state: nextState)
            }
            .store(in: &cancellables)

        contentView.filterTypeList.selectedOption
            .sink(reportImmediately: false) { [weak self] type in
                self?.contentView.load(filter: .make(with: type, basedOn: self?.currentFilter))
            }
            .store(in: &cancellables)

        contentView.ruleValueChanged = { [weak self] in
            self?.runTestIfNeeded()
        }

        contentView.testZoneCard.textField.textChangedCallback = { [weak self] _ in
            self?.runTestIfNeeded()
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backPressed))
    }

    func render(state: FilterDetail.ViewState) {
        switch state {
        case .new: renderNew()
        case let .editing(filter): render(editing: filter)
        }
    }

    func renderNew() {
        navigationItem.titleView = NavigationBar.makeTitle(Copy("FilterDetail.Title.New"))
        let filter: Filter = .make(with: .contains)
        loadedFilter = filter
        contentView.load(filter: filter)
    }

    func render(editing filter: Filter) {
        navigationItem.titleView = NavigationBar.makeTitle(Copy("FilterDetail.Title.Edit"))
        loadedFilter = filter
        contentView.load(filter: filter)
    }

    var currentFilter: Filter {
        Filter(
            identifier: loadedFilter?.identifier ?? UUID(),
            name: contentView.titleField.text ?? "",
            rule: contentView.currentRule,
            isCaseSensitive: contentView.caseSensitiveControl.selectedSegmentIndex == 0,
            order: loadedFilter?.order ?? -1
        )
    }

    func runTestIfNeeded() {
        guard !contentView.testZoneCard.textField.text.isEmpty else {
            contentView.testZoneCard.state = .unknown
            contentView.testZoneCard.statusMessage.text = ""
            return
        }
        let isSpam = controller.test(filter: currentFilter, against: contentView.testZoneCard.textField.text)
        contentView.testZoneCard.state = isSpam ? .spam : .notSpam
        if isSpam {
            contentView.testZoneCard.statusMessage.text = Copy("FilterDetail.TestZone.Match")
        } else {
            contentView.testZoneCard.statusMessage.text = Copy("FilterDetail.TestZone.NoMatch")
        }
    }

}

private extension FilterDetail.ViewController {

    @objc func savePressed() {
        switch controller.validate(filter: currentFilter) {
        case let .failure(error):
            presentError(message: error.localizedDescription)
        case let .success(newFilter):
            controller.save(filter: newFilter)
        }
    }

    @objc func deletePressed() {
        let alert = UIAlertController(title: Copy("FilterDetail.DeleteAlert.Title"), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Copy("FilterDetail.DeleteAlert.Cancel"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Copy("FilterDetail.DeleteAlert.Delete"), style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.controller.delete(filter: self.currentFilter)
        }))
        present(alert, animated: true, completion: nil)
    }

    @objc func backPressed() {
        guard loadedFilter != currentFilter else {
            navigationController?.popViewController(animated: true)
            return
        }

        let alert = UIAlertController(title: Copy("FilterDetail.BackAlert.Title"), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Copy("FilterDetail.BackAlert.Cancel"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Copy("FilterDetail.BackAlert.Discard"), style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }

    func presentError(message: String) {
        let alert = UIAlertController(title: Copy("FilterDetail.Error.GenericTitle"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Copy("FilterDetail.Error.Okay"), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
