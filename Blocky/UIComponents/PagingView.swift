//
//  PagingView.swift
//  Blocky
//
//  Created by Max Chuquimia on 13/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class PagingView: UIView {

    let scrollView: UIScrollView = make {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }

    let pageControl: UIPageControl = make {
        $0.backgroundColor = .clear
        $0.currentPageIndicatorTintColor = Color.cove
        $0.pageIndicatorTintColor = Color.soaring
    }

    let nextPageButton: UIButton = make {
        $0.setImage(UIImage(systemName: "arrow.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
        $0.tintColor = Color.ice
    }

    let closeButton: UIButton = make {
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
        $0.tintColor = Color.ice
        $0.setContentHuggingPriority(.required, for: .vertical)
    }

    var keepsScrollViewAbovePageControl: Bool {
        false
    }

    var bleed: CGFloat {
        0
    }

    required init(pages: [UIView]) {
        super.init(frame: .zero)
        setup(pages: pages)
        bind()
    }

    required init?(coder: NSCoder) { die() }

}

private extension PagingView {

    func setup(pages: [UIView]) {
        translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = pages.count

        let pageStack: UIStackView = make {
            $0.distribution = .fillEqually
            $0.spacing = 0
            $0.axis = .horizontal
            for page in pages {
                $0.addArrangedSubview(page)
            }
        }

        scrollView.addSubview(pageStack)
        addSubview(scrollView)
        addSubview(pageControl)
        addSubview(nextPageButton)
        addSubview(closeButton)

        NSLayoutConstraint.activate(
            pageStack.constraintsFillingSuperview()
        )

        NSLayoutConstraint.activate(
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            scrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -bleed),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: bleed),

            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            nextPageButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor),
            nextPageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CommonMetrics.margin),

            pageStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            pageStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(pages.count))
        )

        if keepsScrollViewAbovePageControl {
            pageControl.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 40).isActive = true
        } else {
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }

        updateButtonDisplay()
    }

    func bind() {
        scrollView.delegate = self
        pageControl.addAction(UIAction { [weak self] _ in self?.updateScrolledPage() }, for: .valueChanged)
        nextPageButton.addAction(UIAction { [weak self] _ in self?.moveToNextPage() }, for: .touchUpInside)
    }

    func updateScrolledPage() {
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(pageControl.currentPage), y: 0), animated: true)
        updateButtonDisplay()
    }

    func updateButtonDisplay() {
        UIView.animate(withDuration: 0.2) {
            self.nextPageButton.alpha = self.isLastPageShowing ? 0.0 : 1.0
        }
    }

    func moveToNextPage() {
        guard !isLastPageShowing else { return }
        pageControl.currentPage += 1
        updateScrolledPage()
    }

    var isLastPageShowing: Bool {
        pageControl.currentPage == pageControl.numberOfPages - 1
    }

}

extension PagingView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int((scrollView.contentOffset.x + (0.5 * scrollView.frame.width)) / scrollView.frame.width)
        updateButtonDisplay()
    }

}
