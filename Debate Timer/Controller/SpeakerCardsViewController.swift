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

        configureGestureRecognizers()
    }

    func configureGestureRecognizers() {
        // Long Press Gesture Recognizer
        let longPressGestureRecognizer =
            UILongPressGestureRecognizer(target: self,
                                         action: #selector(handleLongPressGesture(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 0.0001
        longPressGestureRecognizer.delegate = self
        view.addGestureRecognizer(longPressGestureRecognizer)
    }

    var isPressed = false

    var lastP: CGPoint!

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

    func reset(withNewDebate newDebate: Debate) {
        debate = newDebate
        collectionView?.reloadData()
        self.showSpeaker(atIndex: 0)
    }
}

extension SpeakerCardsViewController {
    @objc internal func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        guard let collectionView = collectionView else { return }

        let p = gestureRecognizer.location(in: self.collectionView)

        let safeRange: CGFloat = 5

        switch gestureRecognizer.state {
        case .began:
            lastP = p
        default:
            break
        }


        if let indexPath = collectionView.indexPathForItem(at: p) {
            // get the cell at indexPath (the one you long pressed)
            let selectedCell = collectionView.cellForItem(at: indexPath)!
            // do stuff with the cell

            switch gestureRecognizer.state {
            case .began:
                handleLongPressBegan(onCell: selectedCell)
            case .ended:
                if abs(p.x - lastP.x) <= safeRange
                    && p.y > collectionView.contentInset.top + 5
                    && p.y < collectionView.frame.height - collectionView.contentInset.bottom - 5 {
                    handleLongPressEndedInside(onCell: selectedCell)
                    delegate?.cardTapped(atIndex: indexPath.row)
                } else {
                    handleLongPressEndedOutside(onCell: selectedCell)
                }
            case .changed:
                if abs(p.x - lastP.x) > safeRange
                    || p.y <= collectionView.contentInset.top + safeRange
                    || p.y > collectionView.frame.height - collectionView.contentInset.bottom - safeRange {
                    handleLongPressEndedOutside(onCell: selectedCell)
                }
            default:
                break
            }
        }
    }

    private struct Transformations {
        static let bottom = CGAffineTransform(scaleX: 0.97, y: 0.97)
        static let middle = CGAffineTransform(scaleX: 0.985, y: 0.985)
        private init() { }
    }

    private struct Shadows {
        static let big: CGFloat = 3
        static let small: CGFloat = 1
        private init() { }
    }

    func animateButtonPress(transformation: CGAffineTransform,
                            shadowHeight height: CGFloat,
                            duration: TimeInterval,
                            ofCell cell: UICollectionViewCell) {

        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.6,
                       options: [.beginFromCurrentState, .allowUserInteraction],
                       animations: {
                        cell.transform = transformation
        },
                       completion: nil)
    }

    private func handleLongPressBegan(onCell cell: UICollectionViewCell) {
        animateButtonPress(transformation: Transformations.bottom,
                           shadowHeight: Shadows.small,
                           duration: isPressed ? 0.3 : 0.4,
                           ofCell: cell)
    }

    private func handleLongPressEndedInside(onCell cell: UICollectionViewCell) {
        animateButtonPress(transformation: .identity,
                           shadowHeight: Shadows.small,
                           duration: isPressed ? 0.3 : 0.5,
                           ofCell: cell)
    }

    private func handleLongPressEndedOutside(onCell cell: UICollectionViewCell) {
        animateButtonPress(transformation: .identity,
                           shadowHeight: isPressed ? Shadows.small : Shadows.big,
                           duration: isPressed ? 0.3 : 0.5,
                           ofCell: cell)
    }
}

extension SpeakerCardsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension SpeakerCardsViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return debate.allSpeeches().count + 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row < debate.allSpeeches().count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpeakerCardCell.reuseID,
                                                          for: indexPath) as! SpeakerCardCell
            cell.viewModel = SpeakerCardCellViewModel(speech: debate.allSpeeches()[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedCollectionViewCell.reuseID,
                                                          for: indexPath) as! RoundedCollectionViewCell
            return cell
        }
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

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

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
