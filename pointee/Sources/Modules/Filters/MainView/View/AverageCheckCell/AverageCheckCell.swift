//
//  AverageCheckCell.swift
//  pointee
//
//  Created by Alexander on 06.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import MultiSlider

class AverageCheckCell: UITableViewCell, NibReusable {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromValue: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toValue: UILabel!
    @IBOutlet weak var minValue: UILabel!
    @IBOutlet weak var maxValue: UILabel!
    
    @IBOutlet weak var sliderContainer: UIView!
    
    lazy var slider: MultiSlider = {
        return MultiSlider()
    }()
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
    
    // MARK: - Logic
    
    func configureCell(_ viewModel: AverageCheckPresentable) {
        titleLabel.text = viewModel.title
        fromLabel.text = viewModel.fromTitle
        fromValue.text = String(viewModel.values.value.min)
        toLabel.text = viewModel.toTitle
        toValue.text = String(viewModel.values.value.max)
        minValue.text = String(viewModel.minValue)
        maxValue.text = String(viewModel.maxValue)
        
        sliderContainer.addSubview(slider)
        slider.fillSuperview()
        
        slider.minimumValue = CGFloat(viewModel.minValue)
        slider.maximumValue = CGFloat(viewModel.maxValue)
        
        slider.value = [CGFloat(viewModel.values.value.min), CGFloat(viewModel.values.value.max)]
        slider.orientation = .horizontal
        slider.snapStepSize = viewModel.checkStep
        slider.isHapticSnap = true
        slider.distanceBetweenThumbs = viewModel.minimumCheckDistance
        slider.tintColor = UIConstants.YellowSelected
        slider.outerTrackColor = UIConstants.SpaceBlueLight
        
        slider.rx.controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self, self.slider.value.count == 2 else { return }
                let min = Int(self.slider.value[0])
                let max = Int(self.slider.value[1])
                self.fromValue.text = String(min)
                self.toValue.text = String(max)
                viewModel.values.accept(AverageCheckValues(min: min, max: max))
            })
            .disposed(by: disposeBag)
    }
}
