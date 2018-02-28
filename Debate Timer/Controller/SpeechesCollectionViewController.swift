//
//  SpeechesCollectionViewController.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import DeviceKit

protocol SpeechCollectionViewCellDelegate: class {
    func cardTapped(at index: Int)
}

final class SpeechesCollectionViewController: UICollectionViewController {

    // MARK: - Public properties

    var delegate: SpeechCollectionViewCellDelegate?

    // MARK: - Private properties

    private var speeches: [Speech]
    private let itemSpacing: CGFloat = Constants.UI.Spacing.large
    private var lastP: CGPoint!

    // MARK: - Initialization

    init(collectionViewLayout layout: UICollectionViewLayout, speeches: [Speech]) {
        self.speeches = speeches

        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestureRecognizers()
    }

    private var shouldLayout = 0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let collectionView = collectionView else { return }

        if shouldLayout < 5 {
            collectionView.collectionViewLayout.invalidateLayout()
            shouldLayout += 1
        }
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                            withVelocity velocity: CGPoint,
                                            targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        guard let collectionView = collectionView, Info.isDevicePhone() else { return }

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

    // MARK: - Private functions

    private func setupViews() {
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.decelerationRate = Info.isDevicePhone() ?
            UIScrollViewDecelerationRateFast :
            UIScrollViewDecelerationRateNormal
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: 40 + (Device().isPhone ? 4 : 19))
        collectionView?.backgroundColor = .clear
        collectionView?.clipsToBounds = false

        collectionView?.register(SpeechCollectionViewCell.self)
        collectionView?.register(ResetDebateCollectionViewCell.self)
    }

    private func setupGestureRecognizers() {
        let longPressGestureRecognizer =
            UILongPressGestureRecognizer(target: self,
                                         action: #selector(handleLongPressGesture(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 0.0001
        longPressGestureRecognizer.delegate = self
        view.addGestureRecognizer(longPressGestureRecognizer)
    }

    // MARK: - Public functions

    func refreshCell(atIndex index: Int, withTimeLeft time: TimeInterval) {
        let indexpath = IndexPath(row: index, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexpath) as? SpeechCollectionViewCell else { return }
        cell.timeLeft = Format.formatTimeInterval(time)
    }

    func reset(withSpeeches speeches: [Speech]) {
        self.speeches = speeches
        collectionView?.reloadData()
        self.showSpeaker(atIndex: 0)
    }
}

// MARK: - LongPressGestureRecognizer implementation

extension SpeechesCollectionViewController {
    @objc internal func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        guard let collectionView = collectionView else { return }

        let p = gestureRecognizer.location(in: self.collectionView)
        let safeRange: CGFloat = 5

        if gestureRecognizer.state == .began {
            lastP = p
        }

        if let indexPath = collectionView.indexPathForItem(at: p) {
            let selectedCell = collectionView.cellForItem(at: indexPath)!

            switch gestureRecognizer.state {
            case .began:
                handleLongPressBegan(onCell: selectedCell)
            case .ended:
                if abs(p.x - lastP.x) <= safeRange
                    && p.y > collectionView.contentInset.top + safeRange
                    && p.y < collectionView.frame.height - collectionView.contentInset.bottom - safeRange {

                    handleLongPressEnded(onCell: selectedCell)
                    delegate?.cardTapped(at: indexPath.row)
                } else {
                    handleLongPressEnded(onCell: selectedCell)
                }
            case .changed:
                if abs(p.x - lastP.x) > safeRange
                    || p.y <= collectionView.contentInset.top + safeRange
                    || p.y > collectionView.frame.height - collectionView.contentInset.bottom - safeRange {

                    handleLongPressEnded(onCell: selectedCell)
                }
            default:
                break
            }
        }
    }

    private func animateButtonPress(transformation: CGAffineTransform,
                            shadowHeight height: CGFloat,
                            ofCell cell: UICollectionViewCell) {

        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.6,
                       options: [.beginFromCurrentState, .allowUserInteraction],
                       animations: { cell.transform = transformation },
                       completion: nil)
    }

    private func handleLongPressBegan(onCell cell: UICollectionViewCell) {
        animateButtonPress(transformation: Constants.UI.Transformations.small,
                           shadowHeight: Constants.UI.Shadows.large,
                           ofCell: cell)
    }

    private func handleLongPressEnded(onCell cell: UICollectionViewCell) {
        animateButtonPress(transformation: .identity,
                           shadowHeight: Constants.UI.Shadows.large,
                           ofCell: cell)
    }
}

// MARK: UIGestureRecognizerDelegate implementation

extension SpeechesCollectionViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: SpeakerCardsViewController data source implementation

extension SpeechesCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        return speeches.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row < speeches.count {
            let cell: SpeechCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.timeLeft = nil
            cell.viewModel = SpeechCollectionViewCellViewModel(speech: speeches[indexPath.row])
            return cell
        } else {
            let cell: ResetDebateCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout implementation

extension SpeechesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let insetsLR = collectionView.contentInset.left + collectionView.contentInset.right
        let insetsTB = collectionView.contentInset.top + collectionView.contentInset.bottom
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let availableHeight: CGFloat = collectionView.frame.height - insetsTB

        var availableWidth: CGFloat
        if Device().isPhone {
            availableWidth = collectionView.frame.width - insetsLR - layout.minimumLineSpacing
        } else {
            availableWidth = (collectionView.frame.width - insetsLR) / 2 - layout.minimumLineSpacing
        }

        return CGSize(width: availableWidth, height: availableHeight)
    }
}

// MARK: - SpeakerCardCollectionViewControllerDelegate implementation

extension SpeechesCollectionViewController: SpeakerCardCollectionViewControllerDelegate {
    func showSpeaker(atIndex index: Int) {
        guard let collectionView = collectionView else { return }

        let newIndexPath = IndexPath(row: index, section: 0)
        if collectionView.numberOfItems(inSection: 0) > index {
            collectionView.scrollToItem(at: newIndexPath, at: .left, animated: true)
        }
    }
}
