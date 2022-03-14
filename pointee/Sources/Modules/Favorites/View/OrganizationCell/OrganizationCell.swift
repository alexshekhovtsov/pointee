//
//  OrganizationCell.swift
//  pointee
//
//  Created by Alexander on 23.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class OrganizationCell: UITableViewCell, NibReusable {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var previewContainer: UIView!
    @IBOutlet weak var preview: UIImageView!
    
    @IBOutlet weak var rightStack: UIStackView!
    
    @IBOutlet weak var topRightBoldLabel: UILabel!
    @IBOutlet weak var topRightRegularLabel: UILabel!
    @IBOutlet weak var topRightIcon: UIImageView!
    
    @IBOutlet weak var bottomRightLabel: UILabel!
    @IBOutlet weak var bottomRightIcon: UIImageView!
    
    @IBOutlet weak var bottomLeftLabel: UILabel!
    @IBOutlet weak var bottomLeftIcon: UIImageView!
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        previewContainer.addShadow()
        if UIDevice.current.isPhone {
            container.addShadow(corners: [.bottomLeft, .bottomRight, .topRight])
        } else {
            container.addShadow()
        }
    }
    
    // MARK: - Logic
    
    func configureCell(_ viewModel: BusinessPresentable) {
        titleLabel.text = viewModel.title
        logo.kf.setImage(with: viewModel.logoURL)
        
        switch viewModel.type {
        case .favorites(let model):
            if let rating = model.rating {
                topRightBoldLabel.text = rating
                topRightRegularLabel.text = model.reviews
            } else {
                topRightIcon.isHidden = true
                topRightRegularLabel.isHidden = true
                topRightBoldLabel.isHidden = true
            }
            
            if let destination = model.distance {
                bottomRightLabel.text = destination
            } else {
                bottomRightLabel.isHidden = true
                bottomRightIcon.isHidden = true
            }
            switch model.businessStatus {
            case .open:
                bottomLeftLabel.textColor = UIConstants.Green
            case .closed:
                bottomLeftLabel.textColor = UIConstants.Red
            case .technicalBreak:
                bottomLeftLabel.textColor = UIConstants.GreyTextField
            }
            if UIDevice.current.isPhone {
                previewContainer.layer.zPosition = -10
                preview.cornerRadius = UIConstants.cornerRadius
                previewContainer.cornerRadius = UIConstants.cornerRadius
                previewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                preview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                previewContainer.layer.zPosition = 10
                preview.cornerRadius = UIConstants.cornerRadius - 4
                previewContainer.cornerRadius = UIConstants.cornerRadius - 4
            }
            preview.kf.setImage(with: model.previewURL)
            bottomLeftLabel.text = model.time
            bottomLeftIcon.image = model.timeIcon
        case .orders(let model):
            rightStack.alignment = .trailing
            
            topRightRegularLabel.text = model.dateTimeTitle
            topRightBoldLabel.isHidden = true
            topRightIcon.isHidden = true
            
            bottomRightLabel.text = model.amount
            bottomRightIcon.isHidden = true
            
            bottomLeftLabel.text = model.orderStatusTitle
            bottomLeftIcon.image = model.orderStatusIcon
        }
    }
}
