//
//  FilterDetail+Controller.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation
import Combine

protocol FilterDetailController {
    var viewState: Variable<FilterDetail.ViewState> { get }
}

extension FilterDetail {

    class Controller: FilterDetailController {

        internal var viewState: Variable<ViewState> = .init(value: .new)
        private var resultClosure: (EditingResult) -> Void

        init(state: ViewState, result: @escaping (EditingResult) -> Void) {
            viewState.value = state
            resultClosure = result
        }

    }

}

extension FilterDetail.Controller {
    
}
