// The MIT License (MIT)
//
// Copyright (c) 2018 Alexander Grebenyuk (github.com/kean).

import UIKit

extension UIStackView {
    @nonobjc public convenience init(style: ((UIStackView) -> Void)...) {
        self.init()
        style.forEach { $0(self) }
    }
}

extension UIView {
    @nonobjc public convenience init(style: ((UIView) -> Void)...) {
        self.init()
        style.forEach { $0(self) }
    }
}

extension UILabel {
    @nonobjc public convenience init(style: ((UILabel) -> Void)...) {
        self.init()
        style.forEach { $0(self) }
    }
}

extension UIButton {
    @nonobjc public convenience init(type: UIButtonType = .system, style: ((UIButton) -> Void)...) {
        self.init(type: type)
        style.forEach { $0(self) }
    }
}

extension UIImageView {
    @nonobjc public convenience init(style: ((UIImageView) -> Void)...) {
        self.init()
        style.forEach { $0(self) }
    }
}

extension UIStackView {
    @nonobjc public convenience init(style: ((UIStackView) -> Void)..., views: [UIView]) {
        self.init(arrangedSubviews: views)
        style.forEach { $0(self) }
    }
}
