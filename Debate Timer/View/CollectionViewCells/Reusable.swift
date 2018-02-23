//
//  Reusable.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 20.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) where T: Reusable {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath,
                                                      _ cellClass: T.Type = T.self) -> T where T: Reusable  {

        let cell = self.dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath)
        guard let typedCell = cell as? T else {
            fatalError("Failed to dequeue cell of type \(cellClass.reuseIdentifier) for index path \(indexPath)")
        }
        return typedCell
    }
}

// MARK: Protocol definition

protocol Reusable {
    static var reuseIdentifier: String { get }
}

// MARK: Default implementation

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: UIStackView extension

public extension UIStackView {
    func insertArrangedSubviews(_ subviews: [UIView]) {
        for (index, view) in subviews.enumerated() {
            self.insertArrangedSubview(view, at: index)
        }
    }
}
