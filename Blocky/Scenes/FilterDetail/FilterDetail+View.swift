//
//  FilterDetail+View.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit
import Combine

extension FilterDetail {

    class View: UIView {

        private enum Metrics {
            static let defaultScrollviewInset: UIEdgeInsets = .init(top: 20, left: 0, bottom: 5, right: 0)
        }

        let scrollView: UIScrollView = make {
            $0.backgroundColor = .clear
            $0.contentInset = Metrics.defaultScrollviewInset
            $0.accessibilityIdentifier = AI.FilterDetail.mainScrollView
        }

        let scrollingStack: UIStackView = make {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 10
        }

        let saveButton: BigButton = make {
            $0.customTitle.text = Copy("FilterDetail.Button.Save")
            $0.accessibilityIdentifier = AI.FilterDetail.saveButton
            ViewStyle.Button.Green.apply(to: $0)
        }
        let deleteButton: BigButton = make {
            $0.customTitle.text = Copy("FilterDetail.Button.Delete")
            ViewStyle.Button.Red.apply(to: $0)
        }

        let contentCard: CardView = make()
        let titleField: CardTitleTextField = make()
        let caseSensitiveControl: UISegmentedControl = make {
            $0.insertSegment(withTitle: Copy("Rule.CaseSensitive.Yes"), at: 0, animated: false)
            $0.insertSegment(withTitle: Copy("Rule.CaseSensitive.No"), at: 1, animated: false)
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
        private var enteredValues: [() -> String] = []

        let filterTypeList = ListView<Filter.Rule.UnderlyingType>(
            options: [.contains, .prefix, .exact, .suffix, .regex],
            selectedOption: .contains
        )

        let testZoneCard: TestZoneView = make()

        let cardStack: UIStackView = make {
            $0.axis = .vertical
            $0.spacing = 18.0
            $0.distribution = .fillProportionally
        }

        private var cancellables: [AnyCancellable] = []

        var ruleValueChanged: () -> () = { }

        init() {
            super.init(frame: .zero)
            setup()
            bind()
        }

        required init?(coder: NSCoder) { die() }

    }

}

extension FilterDetail.View {

    var currentRule: Filter.Rule {
        switch filterTypeList.selectedOption.value {
        case .contains: return .contains(substrings: enteredValues.map({ $0() }))
        case .regex: return .regex(expression: enteredValues[0]())
        case .prefix: return .prefix(string: enteredValues[0]())
        case .exact: return .exact(string: enteredValues[0]())
        case .suffix: return .suffix(string: enteredValues[0]())
        }
    }

    func load(filter: Filter) {
        titleField.text = filter.name
        filterTypeList.select(item: filter.rule.underlyingType)
        caseSensitiveControl.selectedSegmentIndex = filter.isCaseSensitive ? 0 : 1
        enteredValues = []

        // Skip the first two views (title and filter list)
        for view in cardStack.arrangedSubviews[2...] {
            view.removeFromSuperview()
        }

        switch filter.rule {
        case let .contains(substrings):
            addContainsFields(strings: substrings)
        case .exact(string: let value),
             .prefix(string: let value),
             .suffix(string: let value),
             .regex(expression: let value):
            addSingleField(rule: filter.rule, value: value)
        }

        let caseSection = makeCardSection(title: Copy("Filter.Edit.Properties.CaseSensitive.Title"), content: caseSensitiveControl)
        cardStack.addArrangedSubview(caseSection)
    }

}

private extension FilterDetail.View {

    func setup() {
        accessibilityIdentifier = AI.FilterDetail.background

        let scrollViewContent: UIView = make {
            $0.backgroundColor = .clear
        }

        let lowerButtonsStack: UIStackView = make {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 22
            $0.addArrangedSubview(saveButton)
            $0.addArrangedSubview(deleteButton)
        }

        let helpDeck = FilterHelpDeck()

        addSubview(lowerButtonsStack)
        addSubview(scrollView)
        scrollView.addSubview(scrollViewContent)
        scrollViewContent.addSubview(scrollingStack)
        scrollingStack.addArrangedSubview(contentCard)
        scrollingStack.addArrangedSubview(testZoneCard)
        scrollingStack.setCustomSpacing(25, after: testZoneCard)
        scrollingStack.addArrangedSubview(helpDeck)
        contentCard.addSubview(cardStack)
        cardStack.addArrangedSubview(titleField)
        cardStack.addArrangedSubview(
            makeCardSection(title: Copy("Filter.Edit.Properties.Type"), content: filterTypeList)
        )

        NSLayoutConstraint.activate(
            scrollViewContent.constraintsFillingSuperview(),
            scrollingStack.constraintsFillingSuperview(insets: UIEdgeInsets(top: 0, left: CommonMetrics.margin, bottom: 0, right: CommonMetrics.margin)),
            cardStack.constraintsFillingSuperview(insets: CommonMetrics.cardContentInset)
        )

        NSLayoutConstraint.activate(
            scrollingStack.topAnchor.constraint(equalTo: scrollViewContent.topAnchor),
            scrollingStack.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: CommonMetrics.margin),
            scrollingStack.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -CommonMetrics.margin),
            scrollingStack.bottomAnchor.constraint(lessThanOrEqualTo: scrollViewContent.bottomAnchor),

            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            lowerButtonsStack.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            lowerButtonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CommonMetrics.margin),
            lowerButtonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CommonMetrics.margin),
            lowerButtonsStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        )
    }

    func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
        addGestureRecognizer(tap)

        filterTypeList.selectedOption
            .sink(reportImmediately: false) { [weak self] _ in
                self?.ruleValueChanged()
            }
            .store(in: &cancellables)

        caseSensitiveControl.addAction(UIAction { [weak self] _ in self?.ruleValueChanged() }, for: .valueChanged)

        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] (notification) in
                self?.handleKeyboardAppeared(notification: notification)
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] (notification) in
                self?.handleKeyboardDisappeared(notification: notification)
            }
            .store(in: &cancellables)
    }

    func makeCardSection(title: String, content: UIView) -> UIStackView {
        let result: UIStackView = make {
            $0.axis = .vertical
            $0.spacing = 0
        }

        let titleLabel: UILabel = make {
            $0.text = title
            $0.setContentHuggingPriority(.required, for: .vertical)
            ViewStyle.Label.CardProperty.Title.apply(to: $0)
            $0.textAlignment = .left
        }

        result.addArrangedSubview(titleLabel)
        result.addArrangedSubview(content)

        return result
    }

    func addContainsFields(strings: [String]) {
        let value = makeCardValueTextView()
        value.accessibilityIdentifier = AI.FilterDetail.firstValueTextView
        value.placeholderLabel.text = Copy("Filter.Edit.Properties.Contains.Placeholder")
        value.text = strings.first ?? ""
        let section1 = makeCardSection(title: Copy("Filter.Edit.Properties.Contains.Title"), content: value)
        cardStack.addArrangedSubview(section1)

        let value2 = makeCardValueTextView()
        value2.placeholderLabel.text = Copy("Filter.Edit.Properties.Contains.Placeholder2")
        value2.text = strings.second ?? ""
        let section2 = makeCardSection(title: Copy("Filter.Edit.Properties.Contains.Title2"), content: value2)
        cardStack.addArrangedSubview(section2)

        enteredValues.append({ [weak value] in value?.text ?? "" })
        enteredValues.append({ [weak value2] in value2?.text ?? "" })
    }

    func addSingleField(rule: Filter.Rule, value: String) {
        let valueView = makeCardValueTextView()
        valueView.accessibilityIdentifier = AI.FilterDetail.firstValueTextView
        valueView.placeholderLabel.text = rule.valueFieldPlaceholder
        valueView.text = value
        enteredValues.append({ [weak valueView] in valueView?.text ?? "" })
        let section = makeCardSection(title: rule.valueFieldTitle, content: valueView)
        cardStack.addArrangedSubview(section)
    }

    func makeCardValueTextView() -> CardValueTextView {
        make {
            ViewStyle.Field.CardValue.apply(to: $0)
            $0.textChangedCallback = { [weak self] _ in
                self?.ruleValueChanged()
            }
        }
    }

    func handleKeyboardAppeared(notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: Metrics.defaultScrollviewInset.top, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    func handleKeyboardDisappeared(notification: Notification) {
        scrollView.contentInset = Metrics.defaultScrollviewInset
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

}

private extension Filter.Rule {

    var valueFieldTitle: String {
        switch self {
        case .contains: return Copy("Filter.Edit.Properties.Contains.Title")
        case .regex: return Copy("Filter.Edit.Properties.Regex.Title")
        case .prefix: return Copy("Filter.Edit.Properties.Prefix.Title")
        case .exact: return Copy("Filter.Edit.Properties.Exact.Title")
        case .suffix: return Copy("Filter.Edit.Properties.Suffix.Title")
        }
    }

    var valueFieldPlaceholder: String {
        switch self {
        case .contains: return Copy("Filter.Edit.Properties.Contains.Placeholder")
        case .regex: return Copy("Filter.Edit.Properties.Regex.Placeholder")
        case .prefix: return Copy("Filter.Edit.Properties.Prefix.Placeholder")
        case .exact: return Copy("Filter.Edit.Properties.Exact.Placeholder")
        case .suffix: return Copy("Filter.Edit.Properties.Suffix.Placeholder")
        }
    }

}
