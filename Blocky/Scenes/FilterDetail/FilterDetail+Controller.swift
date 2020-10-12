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
    func validate(filter: Filter) -> Result<Filter, FilterDetail.ValidationError>
    func save(filter: Filter)
    func delete(filter: Filter)
    func test(filter: Filter, against sms: String) -> Bool
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

    func validate(filter: Filter) -> Result<Filter, FilterDetail.ValidationError> {
        var name = filter.name.trimmingCharacters(in: .whitespacesAndNewlines)

        if name.isEmpty {
            if filter.firstRuleValue.count < filter.rule.localisedName.count {
                name = "“" + filter.firstRuleValue + "”" + Copy("FilterDetail.AutoName.Suffix")
            } else {
                name = filter.rule.localisedName + Copy("FilterDetail.AutoName.Suffix")
            }
        }

        // Ensure Regex is valid
        if case let .regex(expr) = filter.rule {
            do {
                _ = try Regex(pattern: expr, isCaseSensitive: filter.isCaseSensitive)
            } catch {
                return .failure(.invalidRegex(message: error.localizedDescription))
            }
        }

        // Ensure there is something to match against
        if filter.firstRuleValue.isEmpty {
            return .failure(.emptyValue)
        }

        return .success(Filter(
            identifier: filter.identifier,
            name: name,
            rule: filter.rule,
            isCaseSensitive: filter.isCaseSensitive,
            order: filter.order
        ))
    }

    func save(filter: Filter) {
        guard case let .success(filter) = validate(filter: filter) else { return }

        if case .new = viewState.value {
            resultClosure(.create(filter))
        } else {
            resultClosure(.overwrite(filter))
        }
    }

    func delete(filter: Filter) {
        resultClosure(.delete(filter))
    }

    /// Returns `true` if `sms` is spam
    func test(filter: Filter, against sms: String) -> Bool {
        FilterInterpreter(suspiciousMessage: sms).isSpam(accordingTo: filter)
    }

}
