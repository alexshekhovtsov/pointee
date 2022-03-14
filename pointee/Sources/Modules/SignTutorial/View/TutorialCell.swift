//
//  TutorialCell.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable

class TutorialCell: UICollectionViewCell, NibReusable {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    // MARK: - Logic

    func configureCell(_ viewModel: TutorialPresentable) {
        image.image = viewModel.image
        title.text = viewModel.text
    }
}
