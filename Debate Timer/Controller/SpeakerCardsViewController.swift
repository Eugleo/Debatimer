//
//  SpeakerCardsViewController.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

final class SpeakerCardsViewController: UICollectionViewController {
    var speeches: [Speech] = []
    private let itemSpacing: CGFloat = 10
    private let reuseIdentifier = "speakerCard"

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let collectionView = collectionView else { return }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 10, right: 40)
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
}

extension SpeakerCardsViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return speeches.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! SpeakerCardCell
        let speech = speeches[indexPath.row]
        cell.speaker1 = "\(speech.speaker1)"
        if let speaker2 = speech.speaker2 {
            cell.speaker2 = "\(speaker2)"
        }
        cell.time = speech.timeLimit

        return cell
    }
}

extension SpeakerCardsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let availableWidth = collectionView.frame.width - collectionView.contentInset.left * 2 - itemSpacing
        return CGSize(width: availableWidth, height: collectionView.frame.height - collectionView.contentInset.bottom)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return itemSpacing
    }
}
