//
//  SpeakerCard.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 10/06/2018.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class SpeakerCard: UIView {
    
    // MARK: - Public properties
    
    var speechTimeText = " " {
        didSet {
            speechTimeLabel.text = speechTimeText
        }
    }
    
    var questionsTimeText = " " {
        didSet {
            questionsTimeLabel.text = questionsTimeText
        }
    }
    
    enum Style {
        case red, blue
    }
    var style: Style = .red {
        didSet {
            switch style {
            case .blue:
                headerGradientLayer.colors = [
                    UIColor(red:0.54, green:0.84, blue:1.00, alpha:1.0).cgColor,
                    UIColor(red:0.18, green:0.69, blue:1.00, alpha:1.0).cgColor,
                ]
            case .red:
                headerGradientLayer.colors = [
                    UIColor(red:1.00, green:0.65, blue:0.64, alpha:1.0).cgColor,
                    UIColor(red:0.99, green:0.45, blue:0.50, alpha:1.0).cgColor,
                ]
            }
        }
    }
    
    // MARK: - UI Elements
    
    private let speakerNameLabel = UILabel().with { l in
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.textColor = .white
        l.textAlignment = .center
    }
    
    private let headerView = UIView()
    
    private let speechTimeLabel = UILabel().with { l in
        l.font = UIFont.boldSystemFont(ofSize: 17)
        l.textColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        l.textAlignment = .center
    }
    
    private let questionsTimeLabel = UILabel().with { l in
        l.font = UIFont.systemFont(ofSize: 17)
        l.textColor = .lightGray
        l.textAlignment = .center
    }
    
    private let backgroundGradientLayer = CAGradientLayer()
    private let shadowLayer = CAShapeLayer()
    private let headerGradientLayer = CAGradientLayer()
    
    // MARK: - Initialization
    
    init(speakerName: String) {
        super.init(frame: .zero)
        
        // Setting up individual components of the view
        setupConstraints()
        setupBackgroundGradient()
        setupShadow()
        setupHeader()
        
        // Setting up other UI components
        layer.cornerRadius = Constants.UI.CornerRadius.small
        speakerNameLabel.text = speakerName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private setup functions
    
    private func setupShadow() {
        shadowLayer.fillColor = UIColor.clear.cgColor
        shadowLayer.shadowColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0).cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 3)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 3
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    private func setupHeader() {
        headerView.layer.insertSublayer(headerGradientLayer, at: 0)
    }
    
    private func setupBackgroundGradient() {
        backgroundGradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0).cgColor,
        ]
        backgroundGradientLayer.cornerRadius = Constants.UI.CornerRadius.small
        layer.insertSublayer(backgroundGradientLayer, at: 0)
    }
    
    private func setupConstraints() {
        // Header
        addSubview(headerView) { h in
            h.height.set(40)
            h.leading.pinToSuperview()
            h.trailing.pinToSuperview()
            h.top.pinToSuperview()
        }
        
        addSubview(speakerNameLabel) { l in
            l.center.align(with: headerView.al.center)
        }
        
        // Time labels
        let timesStackView = UIStackView().with { s in
            s.alignment = .fill
            s.axis = .vertical
            s.distribution = .fillEqually
            s.spacing = 0
        }
        timesStackView.insertArrangedSubviewsWithSpacing([speechTimeLabel, questionsTimeLabel])
        addSubview(timesStackView) { s in
            s.top.align(with: headerView.al.bottom)
            s.leading.pinToSuperview()
            s.trailing.pinToSuperview()
            s.bottom.pinToSuperview()
        }
    }
    
    // MARK: - View lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Background gradient
        backgroundGradientLayer.frame = self.bounds
        
        // Redrawing shadow
        let radius = Constants.UI.CornerRadius.small
        let roundedCornerPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shadowLayer.path = roundedCornerPath
        shadowLayer.shadowPath = roundedCornerPath
        shadowLayer.frame = self.bounds
        
        // Redrawing header
        headerGradientLayer.removeFromSuperlayer()
        let headerPath = UIBezierPath(
            roundedRect: headerView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 12, height: 12))
        let headerPathMask = CAShapeLayer()
        headerPathMask.path = headerPath.cgPath
        headerView.layer.mask = headerPathMask
        
        headerGradientLayer.frame = headerView.bounds
        headerView.layer.insertSublayer(headerGradientLayer, at: 0)
    }
}
