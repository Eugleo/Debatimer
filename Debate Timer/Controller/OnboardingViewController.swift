//
//  OnboardingViewController.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class OnboardingViewController: UICollectionViewController {

    // MARK: Public properties

    var onboardingCardViewModels: [OnboardingCardViewModel] = [] {
        didSet {
            pageControl.numberOfPages = onboardingCardViewModels.count
        }
    }

    // MARK: Private UI properties

    private let pageControl = UIPageControl().with { p in
        p.tintColor = Constants.UI.Colors.gray
        p.currentPageIndicatorTintColor = Constants.UI.Colors.affirmative
    }

    private let skipButton = UIButton().with { b in
        b.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        b.backgroundColor = Constants.UI.Colors.gray
        b.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        b.setTitle("Přeskočit", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.layer.cornerRadius = Constants.UI.CornerRadius.medium
    }

    // MARK: Initialization

    init(collectionViewLayout: UICollectionViewLayout, onboardingCardViewModels: [OnboardingCardViewModel]) {
        self.onboardingCardViewModels = onboardingCardViewModels

        super.init(collectionViewLayout: collectionViewLayout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.UI.Colors.almostWhite

        setupCollectionView()
        setupConstraints()
    }

    // MARK: Private functions

    private func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true

        collectionView.register(IntroCollectionViewCell.self)
        collectionView.register(ImageCollectionViewCell.self)
        collectionView.register(EndingCollectionViewCell.self)
        collectionView.backgroundColor = Constants.UI.Colors.almostWhite
    }

    private func setupConstraints() {
        view.addSubview(pageControl) { p in
            p.centerX.alignWithSuperview()
            p.bottom.align(with: view.al.bottom, offset: -20, multiplier: 1, relation: .equal)
        }

        view.addSubview(skipButton) { b in
            b.trailing.pinToSuperview(inset: 20, relation: .equal)
            b.top.pinToSafeArea(of: self, inset: 10, relation: .equal)
        }
    }

    @objc private func skipButtonTapped(_ sender: UIButton) {
        let lastIndex = IndexPath(row: onboardingCardViewModels.count - 1, section: 0)
        collectionView?.scrollToItem(at: lastIndex, at: .centeredHorizontally, animated: true)
        UIView.animate(withDuration: 0.3, animations: { self.skipButton.alpha = 0 })
    }
}

extension OnboardingViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingCardViewModels.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let model = onboardingCardViewModels[indexPath.row]

        switch model.kind {
            case .intro:
                let cell: IntroCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.titleLabel.text = model.title
                cell.descriptionLabel.text = model.description
                return cell
            case .image:
                let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.titleLabel.text = model.title
                cell.descriptionLabel.text = model.description
                cell.imageView.image = model.image!
                return cell
            case .ending:
                let cell: EndingCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.titleLabel.text = model.title
                cell.descriptionLabel.text = model.description
                cell.delegate = self
                return cell
        }
    }

    public override func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                                   withVelocity velocity: CGPoint,
                                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / self.view.frame.width)
        pageControl.currentPage = pageNumber

        if pageNumber == onboardingCardViewModels.count - 1 {
            UIView.animate(withDuration: 0.3, animations: { self.skipButton.alpha = 0 })
        } else {
            UIView.animate(withDuration: 0.3, animations: { self.skipButton.alpha = 1 })
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return collectionView.frame.size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension OnboardingViewController: EndingCollectionViewCellDelegate {
    func buttonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
