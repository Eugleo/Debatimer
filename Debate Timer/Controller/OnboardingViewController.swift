//
//  OnboardingViewController.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    var onboardingCards: [OnboardingCardViewModel] = []

    private enum Keys: String {
        case introCell = "IntroCell"
        case imageCell = "ImageCell"
        case endingCell = "EndingCell"
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!

    @IBAction func skipButtonTapped(_ sender: UIButton) {
        let lastIndex = IndexPath(row: onboardingCards.count - 1, section: 0)
        collectionView.scrollToItem(at: lastIndex, at: .centeredHorizontally, animated: true)
        UIView.animate(withDuration: 0.3, animations: { self.skipButton.alpha = 0 })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never

        pageControl.numberOfPages = onboardingCards.count
    }
}

extension OnboardingViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingCards.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let model = onboardingCards[indexPath.row]

        switch model.kind {
            case .intro:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Keys.introCell.rawValue, for: indexPath) as! IntroCollectionViewCell
                cell.titleLabel.text = model.title
                cell.descriptionLabel.text = model.description
                return cell
            case .image:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Keys.imageCell.rawValue, for: indexPath) as! ImageCollectionViewCell
                cell.titleLabel.text = model.title
                cell.descriptionLabel.text = model.description
                cell.imageView.image = model.image!
                return cell
            case .ending:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Keys.endingCell.rawValue, for: indexPath) as! EndingCollectionViewCell
                cell.titleLabel.text = model.title
                cell.descriptionLabel.text = model.description
                cell.delegate = self
                return cell
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / self.view.frame.width)
        pageControl.currentPage = pageNumber

        if pageNumber == onboardingCards.count - 1 {
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
