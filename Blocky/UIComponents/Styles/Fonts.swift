//
//  FontStyles.swift
//  Blocky
//
//  Created by Max Chuquimia on 8/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

enum Font {

    static let pageTitle = font(name: "Comfortaa-Bold", style: .title1)
    static let tableHeader = font(name: "OpenSans-SemiBold", style: .headline)
    static let cardTitle = font(name: "OpenSans-SemiBold", style: .title3)
    static let cardProperty = font(name: "OpenSans-SemiBold", style: .body)
    static let ruleDescription = font(name: "OpenSans-Regular", style: .callout)

}

private func font(name: String, style: UIFont.TextStyle) -> UIFont {
    let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
    guard let font = UIFont(name: name, size: fontDescriptor.pointSize) else { die() }
    return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
}
