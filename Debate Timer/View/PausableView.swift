//
//  PlayPauseView.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 30.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class PausableView: UIView {

    // MARK: Public properties

    var isPaused: Bool? {
        didSet {
            if isPaused != oldValue {
                toggle()
            }
        }
    }

    // MARK: Private UI properties

    private let imageView = UIImageView()

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }

    // MARK: Private functions

    private func setupConstraints() {
        addSubview(imageView) { v in
            v.edges.pinToSuperview()
        }
    }

    private func toggle() {
        guard let isPaused = isPaused else { return }

        if isPaused {
            animateChange(to: #imageLiteral(resourceName: "Unpause"))
        } else {
            animateChange(to: #imageLiteral(resourceName: "Pause"))
        }
    }

    private func animateChange(to image: UIImage) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.imageView.alpha = 0
        }, completion: { _ in
            self.imageView.image = image
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            self.imageView.alpha = 1
            }, completion: nil)
        })
    }
}
