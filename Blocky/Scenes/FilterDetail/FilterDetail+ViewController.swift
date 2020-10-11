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

    class ViewController: UIViewController {

        private let controller: FilterDetailController
        private var contentView: View { view as! View }
        private var cancellables: [AnyCancellable] = []

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
        controller.viewState
            .sink { [weak self] (nextState) in
                self?.render(state: nextState)
            }
            .store(in: &cancellables)

        contentView.filterTypeList.selectedOption
            .sink(reportImmediately: false) { [weak self] type in
                self?.contentView.load(filter: .new(with: type))
            }
            .store(in: &cancellables)
    }

    func render(state: FilterDetail.ViewState) {
        switch state {
        case .new: renderNew()
        case let .editing(filter): render(editing: filter)
        }
    }

    func renderNew() {
        navigationItem.titleView = makeNavigationBarTitle(Copy("FilterDetail.Title.New"))
        contentView.load(filter: .new(with: .contains))
    }

    func render(editing filter: Filter) {
        navigationItem.titleView = makeNavigationBarTitle(Copy("FilterDetail.Title.Edit"))
        contentView.load(filter: filter)
    }

}
