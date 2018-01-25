//
//  SpeakerCardsViewController.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

protocol SpeakerCardDelegate: class {
    func cardTapped(atIndex index: Int)
}

final class SpeakerCardsViewController: UICollectionViewController {
    var debate: Debate!
    var delegate: SpeakerCardDelegate?

    private let itemSpacing: CGFloat = 20
    private let reuseIdentifier = "speakerCard"

    private var collectionViewHeight: CGFloat = 0.0 {
        didSet {
            guard let collectionView = collectionView else { return }
            if collectionViewHeight != oldValue {
                collectionView.collectionViewLayout.invalidateLayout()
                collectionView.collectionViewLayout.prepare()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let collectionView = collectionView else { return }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.contentInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: 40 + 4)
    }

    override func viewDidLayoutSubviews() {
        guard let collectionView = collectionView else { return }
        collectionViewHeight = collectionView.bounds.size.height
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let collectionView = collectionView else { return }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let insets = collectionView.contentInset.left + collectionView.contentInset.right
        let availableWidth = collectionView.frame.width - insets - itemSpacing
        let availableHeight =
            collectionView.frame.height -
                collectionView.contentInset.bottom -
                collectionView.contentInset.top -
                layout.sectionInset.bottom -
                layout.sectionInset.top
        
        layout.itemSize = CGSize(width: availableWidth, height: availableHeight)
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                            withVelocity velocity: CGPoint,
                                            targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        guard let collectionView = collectionView else { return }
        let insetFrame = UIEdgeInsetsInsetRect(scrollView.frame, scrollView.contentInset)
        var index = collectionView.contentOffset.x / insetFrame.size.width

        switch velocity.x {
        case let x where x < 0:
            index = floor(index)
        case 0:
            index = round(index)
        default:
            index = ceil(index)
        }
        let newOffset = insetFrame.size.width * index
        let tmp = collectionView.contentSize.width - insetFrame.size.width
        targetContentOffset.pointee.x = (newOffset > tmp ? tmp : newOffset) - scrollView.contentInset.left
    }

    func refreshCell(atIndex index: Int) {
        guard let collectionView = collectionView else { return }

        let speech = debate.allSpeeches()[index]
        if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? SpeakerCardCell {
            cell.viewModel = SpeakerCardCellViewModel(speech: speech)
        }
    }
}

extension SpeakerCardsViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return debate.allSpeeches().count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! SpeakerCardCell
        cell.viewModel = SpeakerCardCellViewModel(speech: debate.allSpeeches()[indexPath.row])

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

        delegate?.cardTapped(atIndex: indexPath.row)
    }
}

extension SpeakerCardsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let insets = collectionView.contentInset.left + collectionView.contentInset.right
        let availableWidth = collectionView.frame.width - insets - itemSpacing
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let availableHeight =
            collectionViewHeight -
            collectionView.contentInset.bottom -
            collectionView.contentInset.top -
            layout.sectionInset.bottom -
            layout.sectionInset.top
        return CGSize(width: availableWidth, height: availableHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return itemSpacing
    }
}

extension SpeakerCardsViewController: SpeakerCardCollectionViewControllerDelegate {
    func showSpeaker(atIndex index: Int) {
        guard let collectionView = collectionView else { return }

        let newIndexPath = IndexPath(row: index, section: 0)
        if collectionView.numberOfItems(inSection: 0) > index {
            collectionView.scrollToItem(at: newIndexPath, at: .left, animated: true)
        }
    }
}
