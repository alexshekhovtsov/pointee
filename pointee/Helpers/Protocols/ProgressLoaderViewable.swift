//
//  ProgressLoaderViewable.swift
//  pointee
//
//  Created by Alexander on 30.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

/// Progress Loader Viewable
protocol ProgressLoaderViewable {}

extension ProgressLoaderViewable {
    
    /// Start Loader Animation
    func startLoaderAnimating(withBackgroundColor backgroundColor: UIColor = .clear) {
        let activityData = ActivityData(size: CGSize(width: 70, height: 70),
                                        message: R.string.localizable.loading(),
                                        messageFont: .appFontBold(atSize: UIConstants.fontSize),
                                        messageSpacing: 5,
                                        type: .ballScaleMultiple,
                                        color: UIConstants.YellowSelected,
                                        padding: nil,
                                        displayTimeThreshold: nil,
                                        minimumDisplayTime: 2,
                                        backgroundColor: UIColor.black.withAlphaComponent(0.5),
                                        textColor: .white)
        DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        }
    }
    
    /// Stop Loader Animation
    func stopLoaderAnimation() {
        DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
}
