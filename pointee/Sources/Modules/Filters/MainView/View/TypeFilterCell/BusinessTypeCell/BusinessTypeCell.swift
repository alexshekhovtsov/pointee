//
//  BusinessTypeCell.swift
//  pointee
//
//  Created by Alexander on 05.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class BusinessTypeCell: UITableViewCell, NibReusable {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
    
    // MARK: - Logic
    
    func configureCell(_ viewModel: TypePresentable) {
        checkImage.image = viewModel.image
        titleLabel.text = viewModel.title
        checkImage.alpha = viewModel.aplha
        titleLabel.alpha = viewModel.aplha
    }
}
