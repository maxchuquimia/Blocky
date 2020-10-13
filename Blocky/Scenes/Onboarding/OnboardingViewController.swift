//
//  OnboardingViewController.swift
//  Blocky
//
//  Created by Max Chuquimia on 13/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit
import SafariServices

class OnboardingViewController: BaseViewController {

    private let page1 = Page1()

    private lazy var pageView = PagingView(pages: [
        page1,
        Page2(),
        Page3(),
        Page4()
    ])

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }

    func setup() {
        view.addSubview(pageView)

        NSLayoutConstraint.activate(
            pageView.constraintsFillingSuperview()
        )
    }

    func bind() {
        pageView.closeButton.addAction(UIAction { [weak self] _ in self?.presentingViewController?.dismiss(animated: true, completion: nil) }, for: .touchUpInside)

        page1.button.addAction(UIAction { [weak self] _ in
            let safari = SFSafariViewController(url: URL(string: "https://github.com/maxchuquimia/Blocky")!)
            self?.present(safari, animated: true, completion: nil)
        }, for: .touchUpInside)
    }

    func scrollToLastPage() {
        pageView.pageControl.currentPage = pageView.pageControl.numberOfPages - 1
        pageView.pageControl.sendActions(for: .valueChanged)
    }

}

private class Page1: OnboardingPage {

    let button: BigButton = make {
        $0.setTitle(Copy("Onboarding.Page1.Button" ), for: .normal)
        ViewStyle.Button.Blue.apply(to: $0)
    }

    override func setup() {
        super.setup()
        titleLabel.text = Copy("Onboarding.Page1.Title")
        contentLabel.text = Copy("Onboarding.Page1.Content")
        contentStack.addArrangedSubview(button)
        addFlexibleSpace()
    }

}

private class Page2: OnboardingPage {

    override func setup() {
        super.setup()
        titleLabel.text = Copy("Onboarding.Page2.Title")
        contentLabel.text = Copy("Onboarding.Page2.Content")

        let imageView: UIImageView = make {
            $0.image = UIImage(named: "onboarding-spam")
            $0.contentMode = .bottom
        }

        addFlexibleSpace()
        contentStack.addArrangedSubview(imageView)
    }

}

private class Page3: OnboardingPage {

    override func setup() {
        super.setup()
        titleLabel.text = Copy("Onboarding.Page3.Title")
        contentLabel.text = Copy("Onboarding.Page3.Content")

        let card = FilterSummaryCell()
        card.load(filter: Filter(identifier: UUID(), name: "New Filter", rule: .contains(substrings: ["Click Here"]), isCaseSensitive: false, order: 0), isEnabled: true)
        card.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true

        contentStack.addArrangedSubview(card)
        addFlexibleSpace()
    }

}

private class Page4: OnboardingPage {

    override func setup() {
        super.setup()
        titleLabel.text = Copy("Onboarding.Page4.Title")
        contentLabel.text = Copy("Onboarding.Page4.Content")

        let imageView: UIImageView = make {
            $0.image = UIImage(named: "onboarding-settings")
            $0.contentMode = .bottom
        }

        addFlexibleSpace()
        contentStack.addArrangedSubview(imageView)
    }

}
