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
    }

    func render(state: FilterDetail.ViewState) {
        switch state {
        case .new: break
        case .editing(_): break
        }
    }

}
