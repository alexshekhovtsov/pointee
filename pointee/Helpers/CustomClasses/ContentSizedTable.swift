//
//  ContentSizedTable.swift
//  pointee
//
//  Created by Alexander on 25.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit

final class ContentSizedTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
