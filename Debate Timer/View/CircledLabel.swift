//
//  CircledLabel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 20.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class CircledLabel: UIView {

    // MARK: - Public UI properties

    var font: UIFont = UIFont.systemFont(ofSize: 17, weight: .semibold) {
        didSet {
            titleLabel.font = font
        }
    }

    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }

    // MARK: - Private UI properties

    private let titleLabel = UILabel().with { l in
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        l.textAlignment = .center
        l.layer.masksToBounds = true
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Not yet implemented init(coder:)")
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        layer.cornerRadius = frame.height / 2
        super.layoutSubviews()
    }

    // MARK: - Private functions
    
    private func setupTitleLabel() {
        addSubview(titleLabel) { l in
            l.edges.pinToSuperview()
        }
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
    }
}
