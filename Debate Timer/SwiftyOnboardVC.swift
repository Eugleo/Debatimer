//
//  SwiftyOnboardVC.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import Yalta

@objc public protocol SwiftyOnboardVCDelegate: class {
    @objc optional func leftButtonPressed()
    @objc optional func rightButtonPressed()
    @objc optional func bottomButtonPressed()
    @objc optional func pageDidChange(currentPage: Int)
}

@objc open class SwiftyOnboardVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: Public variables

    //Delegate
    open weak var delegate: SwiftyOnboardVCDelegate?

    //View controllers array
    public var viewControllers: [UIViewController]  = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    //Collection view settings
    public var backgroundColor: UIColor = .white
    public var bounces: Bool = true
    public var showHorizontalScrollIndicator = false

    //Page control settings
    public var showPageControl = true
    public var pageControlTintColor: UIColor = .lightGray
    public var currentPageControlTintColor: UIColor = .black
    public var pageControlBottomMargin: CGFloat = 0

    //Right button settings
    public var showRightButton: Bool = true
    public var rightButtonText: String = "Next"
    public var rightButtonTextColor: UIColor = .black
    public var rightButtonBackgroundColor: UIColor = .orange
    public var rightButtonCornerRadius: CGFloat = 0
    public var rightButtonHeightPadding: CGFloat = 5
    public var rightButtonWidthPadding: CGFloat = 5

    //Button top margin
    public var buttonTopMargin: CGFloat = 5

    //Status bar
    public var hideStatusBar: Bool = false

    //MARK: Private variables
    private let navigationBar: UINavigationBar = UINavigationBar()
    private var buttonTopConstant: CGFloat = 5
    private var leftButtonTopConstriant: NSLayoutConstraint?
    private var rightButtonTopConstriant: NSLayoutConstraint?
    private var bottomButtonBottomConstriant: NSLayoutConstraint?
    private var pageControlBottomConstriant: NSLayoutConstraint?
    private let pageControl: UIPageControl = {
        let p = UIPageControl()
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var bottomButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(bottomButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.footerReferenceSize = .zero
        layout.headerReferenceSize = .zero
        return cv
    }()

    //MARK: Set up status bar
    override open var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }

    //MARK: initializers
    convenience public init(viewControllers: [UIViewController]) {
        self.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: View controller override
    override open func viewDidLoad() {
        super.viewDidLoad()

        collectionView.contentInsetAdjustmentBehavior = .never

        collectionView.collectionViewLayout.invalidateLayout()

        //Register cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        //Set the collection view constants and add to view
        view.addSubview(collectionView) { cv in
            cv.edges.pinToSuperview()
        }
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //Remove the controls from the superview so we can reset there settings
        pageControl.removeFromSuperview()
        rightButton.removeFromSuperview()

        //Check if we have a navigation bar and status bar
        if let navBar = self.navigationController?.navigationBar {
            if(navBar.isHidden) {
                if UIApplication.shared.isStatusBarHidden {
                    buttonTopConstant = buttonTopMargin
                } else {
                    buttonTopConstant = UIApplication.shared.statusBarFrame.height + buttonTopMargin
                }
            } else {
                if !UIApplication.shared.isStatusBarHidden {
                    self.edgesForExtendedLayout = []
                }
                buttonTopConstant = buttonTopMargin
            }
        } else {
            if UIApplication.shared.isStatusBarHidden {
                buttonTopConstant = buttonTopMargin
            } else {
                buttonTopConstant = UIApplication.shared.statusBarFrame.height + buttonTopMargin
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }

        //Set the collection view settings
        collectionView.backgroundColor = backgroundColor
        collectionView.bounces = bounces
        collectionView.showsHorizontalScrollIndicator = showHorizontalScrollIndicator

        //Set the page control settings
        pageControl.numberOfPages = viewControllers.count
        pageControl.pageIndicatorTintColor = pageControlTintColor
        pageControl.currentPageIndicatorTintColor = currentPageControlTintColor
        //Check to see if we should show the page control
        if showPageControl {
            //Add the page control and constriants
            self.view.addSubview(pageControl)
            pageControlBottomConstriant = pageControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: pageControlBottomMargin, rightConstant: 0, widthConstant: 0, heightConstant: 40)[1]
        }

        //Set the right button settings
        rightButton.setTitle(rightButtonText, for: .normal)
        rightButton.setTitleColor(rightButtonTextColor, for: .normal)
        rightButton.layer.backgroundColor = rightButtonBackgroundColor.cgColor
        rightButton.layer.cornerRadius = rightButtonCornerRadius
        rightButton.contentEdgeInsets = UIEdgeInsetsMake(rightButtonHeightPadding, rightButtonWidthPadding, rightButtonHeightPadding, rightButtonWidthPadding)
        //Check to see if we should show the right button
        if showRightButton {
            //Add the right button and constriants
            self.view.addSubview(rightButton)
            rightButtonTopConstriant = rightButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: buttonTopConstant, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: rightButton.frame.width, heightConstant: rightButton.frame.height).first
        }

        //Check if we have view controllers
        if(viewControllers.count == 0) {
            print("Warning: Please set the viewControllers array.")
        } else {
            //Set the collection view and page control to be at the start
            pageControl.currentPage = 0
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }

    //MARK: Handle device rotation

    override open func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            if UIApplication.shared.isStatusBarHidden {
                leftButtonTopConstriant?.constant = buttonTopMargin
                rightButtonTopConstriant?.constant = buttonTopMargin
            }
        } else {
            leftButtonTopConstriant?.constant = buttonTopConstant
            rightButtonTopConstriant?.constant = buttonTopConstant
        }

        collectionView.collectionViewLayout.invalidateLayout()
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)

        //scroll to indexPath after the rotation is going
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            self.collectionView.reloadData()
        }
    }

    //MARK: Collection view datasource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        display(contentController: viewControllers[indexPath.row], on: cell.contentView)
        return cell
    }

    //MARK: Collection view scrollview delegate
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / self.view.frame.width)
        pageControl.currentPage = pageNumber
        delegate?.pageDidChange?(currentPage: pageNumber + 1)
    }

    //MARK: Collection view flow layout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    //MARK: Custom functions
    private func display(contentController content: UIViewController, on view: UIView) {
        self.addChildViewController(content)
        //content.view.frame = view.bounds
        view.subviews.forEach { $0.removeFromSuperview() }

        view.addSubview(content.view) { v in
            v.edges.pinToSuperview()
        }
        content.didMove(toParentViewController: self)
    }

    @objc private func leftButtonPressed() {
        delegate?.leftButtonPressed?()
    }

    @objc private func rightButtonPressed() {
        delegate?.rightButtonPressed?()
    }

    @objc private func bottomButtonPressed() {
        delegate?.bottomButtonPressed?()
    }

    public func nextPage() {
        //Check if we are on the last page
        if pageControl.currentPage == viewControllers.count - 1 {
            return
        }

        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
        delegate?.pageDidChange?(currentPage: pageControl.currentPage + 1)
    }

    public func previousPage() {
        //Check if we are on the first page
        if pageControl.currentPage == 0 {
            return
        }
        let indexPath = IndexPath(item: pageControl.currentPage - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage -= 1
        delegate?.pageDidChange?(currentPage: pageControl.currentPage + 1)
    }

    public func skip() {
        let indexPath = IndexPath(item: viewControllers.count - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = viewControllers.count
        delegate?.pageDidChange?(currentPage: viewControllers.count)
    }

    public func moveRightButtonOffScreen() {
        if showRightButton {
            rightButtonTopConstriant?.constant = -40
        } else {
            print("Tried moving the right button off screen but the right button is set to hidden.")
        }
    }

    public func moveRightButtonOnScreen() {
        if showRightButton {
            rightButtonTopConstriant?.constant = buttonTopConstant
        } else {
            print("Tried moving the right button onto screen but the right button is hidden")
        }
    }

    public func movePageControlOffScreen() {
        if showPageControl {
            pageControlBottomConstriant?.constant = 40
        } else {
            print("Tried moving the page control off screen but the page control is set to hidden.")
        }
    }

    public func movePageControlOnScreen() {
        if showPageControl {
            pageControlBottomConstriant?.constant = -pageControlBottomMargin
        } else {
            print("Tried moving the page control onto screen but the page control is set to hidden.")
        }
    }

    public func updateView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

private extension UIView {

    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }

    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
    }

    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()

        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }

        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }

        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }

        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }

        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }

        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }

        anchors.forEach({$0.isActive = true})

        return anchors
    }
}

public enum ButtonImagePosition {
    // The left position is a default
    case left
    // The right position is useful to display arrows
    case right
    // In case you don't have a title on the button, so above variants make no sense
    case buttonHasNoTitle
}
