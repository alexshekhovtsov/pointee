//
//  ContentSizedCollection.swift
//  pointee
//
//  Created by Alexander on 05.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit

final class ContentSizedCollection: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}
