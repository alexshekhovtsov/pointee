//
//  TagCell.swift
//  pointee
//
//  Created by Alexander on 05.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class TagCell: UICollectionViewCell, NibReusable {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Logic
    
    func configureCell(_ viewModel: String) {
        titleLabel.text = viewModel
    }
}
