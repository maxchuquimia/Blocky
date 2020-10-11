//
//  SettingsExampleViewController.swift
//  Blocky
//
//  Created by Max Chuquimia on 11/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class SettingsExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: make this nicer
        navigationItem.titleView = makeNavigationBarTitle("iOS SMS Filtering")

        let label: UILabel = make {
            $0.font = Font.banner
            $0.textColor = .white
            $0.numberOfLines = 0
            $0.text =
                """
                Before Blocky can start filtering spam SMS messages sent to this device you'll need to set your SMS Filter in Settings:


                1. Open “Settings”

                2. Tap “Messages”

                3. Tap “Unknown & Spam”

                4. Select “Blocky”
                """
        }

        view.backgroundColor = Color.koamaru
        view.addSubview(label)

        NSLayoutConstraint.activate(
            label.constraintsFillingSuperview(insets: UIEdgeInsets(top: 50, left: 30, bottom: 50, right: 30))
        )
    }

}
