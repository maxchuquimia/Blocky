//
//  BaseViewController.swift
//  Blocky
//
//  Created by Max Chuquimia on 11/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.koamaru

        let image = UIImage(named: "hexagon")!
        let imageView: UIImageView = make {
            $0.image = image
            $0.contentMode = .scaleAspectFit
            $0.accessibilityTraits = .notEnabled
            $0.alpha = 0.1
        }

        view.insertSubview(imageView, at: 0)

        NSLayoutConstraint.activate(
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: image.size.width / image.size.height)
        )
    }

}
