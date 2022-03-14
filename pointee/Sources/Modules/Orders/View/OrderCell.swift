//
//  OrderCell.swift
//  pointee
//
//  Created by Alexander on 08.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class OrderCell: UITableViewCell, NibReusable {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        container.addShadow()
    }
    
    // MARK: - Logic
    
    func configureCell(_ viewModel: OrderPresentable) {
        logo.kf.setImage(with: viewModel.logoURL)
        titleLabel.text = viewModel.title
        status.text = viewModel.orderStatusTitle
        statusIcon.image = viewModel.orderStatusIcon
        date.text = viewModel.dateTimeTitle
        amount.text = viewModel.amount
    }
}
