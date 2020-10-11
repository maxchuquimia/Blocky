//
//  ListView.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

protocol ListOption {
    var title: String { get }
}

class ListView<Option: ListOption>: UIStackView {

    let options: [Option]
    private(set) var selectedOption: Variable<Option>

    private var relationMap: [(button: UIButton, label: UILabel)] = []

    init(options: [Option], selectedOption: Option) {
        self.options = options
        self.selectedOption = .init(value: selectedOption)
        super.init(frame: .zero)
        setup()
    }

    required init(coder: NSCoder) { die() }

}


extension ListView {

    func select(item: Option) {
        guard let idx = options.firstIndex(where: { $0.title == item.title }) else { return }
        let button = relationMap[idx].button
        handlePress(from: button)
    }

}

private extension ListView {

    func setup() {
        axis = .vertical

        for option in options {
            let (view, button) = makeAndStoreRow(text: option.title)
            addArrangedSubview(view)

            button.addAction(for: .touchUpInside) { [weak self, weak button] in
                guard let button = button else { return }
                self?.handlePress(from: button)
                self?.selectedOption.value = option
            }

            if option.title == selectedOption.value.title {
                // Initially selected item
                handlePress(from: button)
            }
        }
    }

    func makeAndStoreRow(text: String) -> (UIView, UIButton) {
        let button: UIButton = make {
            $0.setTitle(text, for: .normal)
            $0.contentHorizontalAlignment = .left
            $0.contentEdgeInsets = UIEdgeInsets(top: 0.01, left: 0.01, bottom: 0.01, right: 0.01)
            $0.titleEdgeInsets = UIEdgeInsets(top: 0.01, left: 0.01, bottom: 0.01, right: 0.01)
            $0.tintColor = Color.koamaru
            if let label = $0.titleLabel {
                ViewStyle.Label.CardProperty.Value.apply(to: label)
            }
        }

        let checkmarkLabel: UILabel = make {
            ViewStyle.Label.CardProperty.Value.applyBold(to: $0)
            $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
        }

        let stack: UIStackView = make {
            $0.axis = .horizontal
            $0.addArrangedSubview(checkmarkLabel)
            $0.addArrangedSubview(button)
        }

        // Store this row in the map so we can look up indexes later
        relationMap.append((button, checkmarkLabel))

        return (stack, button)
    }

    func handlePress(from button: UIButton) {
        relationMap.forEach {
            if $0.button === button {
                $0.label.text = "✓"
                ViewStyle.Label.CardProperty.Value.applyBold(to: $0.button.titleLabel!)
            } else {
                $0.label.text = ""
                ViewStyle.Label.CardProperty.Value.apply(to: $0.button.titleLabel!)
            }
        }
    }

}
