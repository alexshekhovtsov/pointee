//
//  TagItemCell.swift
//  pointee
//
//  Created by Alexander on 05.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class TagItemCell: UITableViewCell, NibReusable {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var check: UIImageView!
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
    
    // MARK: - Logic
    
    func configureCell(_ viewModel: SelectableTagPresentable) {
        titleLabel.text = viewModel.title
        check.isHidden = !viewModel.isOn
    }
}
