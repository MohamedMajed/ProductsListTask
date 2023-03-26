//
//  UICollectionView+Extensions.swift
//  ProductsListTask
//
//  Created by Mohamed Maged on 23/03/2023.
//

import UIKit

public extension UICollectionView {
    enum Kind: String {
        case header
        case footer

        public var rawValue: String {
            switch self {
            case .header:
                return UICollectionView.elementKindSectionHeader
            case .footer:
                return UICollectionView.elementKindSectionFooter
            }
        }

        public init?(rawValue: String) {
            switch rawValue {
            case UICollectionView.elementKindSectionHeader:
                self = .header
            case UICollectionView.elementKindSectionFooter:
                self = .footer
            default:
                return nil
            }
        }
    }

    func register(cellType types: UICollectionViewCell.Type...) {
        types.forEach { type in
            let name = String(describing: type)
            let bundle = Bundle(for: type)
            if bundle.path(forResource: name, ofType: "nib") != nil {
                register(UINib(nibName: name, bundle: bundle), forCellWithReuseIdentifier: name)
            } else {
                register(type, forCellWithReuseIdentifier: name)
            }
        }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as! T
    }

    func register(supplementaryViewType types: UICollectionReusableView.Type..., forKind kind: Kind) {
        types.forEach { type in
            let name = String(describing: type)
            let bundle = Bundle(for: type)
            if bundle.path(forResource: name, ofType: "nib") != nil {
                register(UINib(nibName: name, bundle: bundle), forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: name)
            } else {
                register(type, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: name)
            }
        }
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(withType type: T.Type, for indexPath: IndexPath, ofKind kind: Kind) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: String(describing: type), for: indexPath) as! T
    }
}
