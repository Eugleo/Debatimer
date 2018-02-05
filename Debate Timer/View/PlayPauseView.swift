//
//  PlayPauseView.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 30.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class PlayPauseView: UIView {
    private let pauseImgView = UIImageView(image: #imageLiteral(resourceName: "Pause.png"))
    private let unpauseImgView = UIImageView(image: #imageLiteral(resourceName: "Unpause.png"))

    var isPaused: Bool? {
        didSet {
            if isPaused != oldValue {
                toggle()
            }
        }
    }

    private func toggle() {
        guard let isPaused = isPaused else { return }

        if !isPaused {
            addSubview(pauseImgView) { v in
                v.edges.pinToSuperview()
            }
            animateChange(from: unpauseImgView, to: pauseImgView)
        } else {
            addSubview(unpauseImgView) { v in
                v.edges.pinToSuperview()
            }
            animateChange(from: pauseImgView, to: unpauseImgView)
        }
    }

    private func animateChange(from view1: UIImageView, to view2: UIImageView) {
        view2.alpha = 0
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        view1.alpha = 0
                        view2.alpha = 1
        }, completion: nil)
        view1.removeFromSuperview()
    }
}
