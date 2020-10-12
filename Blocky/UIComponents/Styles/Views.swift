//
//  ViewStyles.swift
//  Blocky
//
//  Created by Max Chuquimia on 9/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

enum ViewStyle {

    enum Label {

        enum TableHeader {
            static func apply(to label: UILabel) {
                label.textColor = Color.ice
                label.font = Font.tableHeader
            }
        }

        enum CardHeader {
            static func apply(to label: UILabel) {
                label.textColor = Color.black
                label.font = Font.cardTitle
                label.textAlignment = .center
            }
        }

        enum Footnote {
            static func apply(to label: UILabel) {
                label.textColor = Color.black
                label.font = Font.footnote
            }
        }

        enum CardProperty {

            enum Title {
                static func apply(to label: UILabel) {
                    label.textColor = Color.grey
                    label.font = Font.cardProperty
                    label.textAlignment = .right
                }
            }

            enum Value {
                static func apply(to label: UILabel) {
                    label.textColor = Color.cove
                    label.font = Font.cardProperty
                    label.textAlignment = .left
                }

                static func applyBold(to label: UILabel) {
                    label.textColor = Color.cove
                    label.font = Font.cardPropertyBold
                }
            }

        }

        enum PageTitle {
            static func apply(to label: UILabel) {
                label.font = Font.pageTitle
                label.textColor = Color.ice
            }
        }

        enum Banner {
            static func apply(to label: UILabel) {
                label.font = Font.banner
                label.textColor = Color.cove
                label.numberOfLines = 2
            }
        }

    }

    enum Button {

        enum Green {
            static func apply(to button: BigButton) {
                button.customTitle.font = Font.bigButton
                button.customTitle.textColor = Color.cove
                button.background.backgroundColor = Color.bud
            }
        }

        enum Red {
            static func apply(to button: BigButton) {
                button.customTitle.font = Font.bigButton
                button.customTitle.textColor = Color.white
                button.background.backgroundColor = Color.carmine
            }
        }

        enum Blue {
            static func apply(to button: BigButton) {
                button.customTitle.font = Font.bigButton
                button.customTitle.textColor = Color.cove
                button.background.backgroundColor = Color.soaring
            }
        }

    }

    enum Field {

        enum CardValue {
            static func apply(to field: CardValueTextView) {
                field.placeholderLabel.font = Font.placeholder
                field.placeholderLabel.textColor = Color.placeholder
                field.font = Font.cardProperty
                field.textColor = Color.cove
            }
        }

        enum TestZone {
            static func apply(to field: CardValueTextView) {
                field.placeholderLabel.font = Font.placeholder
                field.placeholderLabel.textColor = Color.placeholder
                field.font = Font.cardProperty
                field.textColor = Color.cove
                field.line.backgroundColor = Color.cove
                field.backgroundColor = .clear
            }
        }
    }

}
