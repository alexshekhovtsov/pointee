//
//  ProductCell.swift
//  pointee
//
//  Created by Alexander on 26.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class ProductCell: UITableViewCell, NibReusable {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var countContainer: UIView!
    @IBOutlet weak var count: UILabel!
    
    private var fakeContainer: UIView!
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    private let fakeContainerInsets = UIEdgeInsets(top: 11, left: 12, bottom: 5, right: 12)
    
    private var containerRotationAngle: CGFloat {
        return UIDevice.current.isPhone ? (.pi / 180) * -3 : (.pi / 180) * -2
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        title.text = ""
        container.removeShadow()
        super.prepareForReuse()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        container.addShadow()
    }
    
    // MARK: - Logic
    
    func configureCell(_ viewModel: ProductPresentable) {
        productImage.kf.setImage(with: viewModel.productImage)
        title.text = viewModel.title
        price.text = viewModel.price
        
        if viewModel.count > 1 {
            countContainer.isHidden = false
            count.text = String(viewModel.count)
            
            fakeContainer = UIView(backgroundColor: .white)
            addSubview(fakeContainer)
            fakeContainer.fillSuperview(padding: fakeContainerInsets)
            let rotationAngle = containerRotationAngle
            fakeContainer.transform = CGAffineTransform(rotationAngle: rotationAngle)
            fakeContainer.layer.zPosition = -1
            fakeContainer.cornerRadius = UIConstants.cornerRadius
        } else {
            countContainer.isHidden = true
            fakeContainer?.removeFromSuperview()
            fakeContainer = nil
        }
    }
}
