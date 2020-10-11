//
//  TextField.swift
//  Blocky
//
//  Created by Max Chuquimia on 11/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class CardTitleTextField: UITextField {

    private let line: UIView = make {
        $0.backgroundColor = Color.soaring
    }

    init() {
        super.init(frame: .zero)
        setup()
        bind()
    }

    required init?(coder: NSCoder) { die() }

}

private extension CardTitleTextField {

    func setup() {
        textColor = Color.cove
        font = Font.cardTitle
        textAlignment = .center
        returnKeyType = .done
        autocapitalizationType = .sentences
        attributedPlaceholder = NSAttributedString(
            string: Copy("Filter.Edit.Properties.Name.Placeholder"),
            attributes: [
                .font: Font.placeholder,
                .foregroundColor: Color.placeholder
            ]
        )

        addSubview(line)

        NSLayoutConstraint.activate(
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.bottomAnchor.constraint(equalTo: bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 0.5)
        )
    }

    func bind() {
        delegate = self
    }

}

extension CardTitleTextField: UITextFieldDelegate {

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
