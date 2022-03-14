//
//  UIConstants.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit

enum UIConstants {
    
    static let SpaceBlue = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.2588235294, alpha: 1)
    static let SpaceBlueLight = #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.3568627451, alpha: 1)
    static let YellowSelected = #colorLiteral(red: 0.9333333333, green: 0.7058823529, blue: 0.2431372549, alpha: 1)
    static let GreyBackground = #colorLiteral(red: 0.9411764706, green: 0.937254902, blue: 0.937254902, alpha: 1)
    static let GreyTextField = #colorLiteral(red: 0.8509803922, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
    static let Red = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3764705882, alpha: 1)
    static let Green = #colorLiteral(red: 0, green: 0.6941176471, blue: 0.3607843137, alpha: 1)
    
    static let fontSizeSmall: CGFloat = 13
    static let fontSize: CGFloat = 17
    static let fontSizeMiddle: CGFloat = 24
    static let fontSizeBig: CGFloat = 34
    /// Default minimum margin and spacing for views
    static let marginMinimum: CGFloat = 5
    /// Default small margin and spacing for views
    static let marginS: CGFloat = 16
    /// Default middle margin and spacing for views
    static let marginM: CGFloat = 24
    /// Default large margin and spacing for views
    static let marginL: CGFloat = 33
    /// Default minimum corner radius for views and buttons
    static let cornerRadiusMinimum: CGFloat = 5
    /// Default corner radius for views and buttons
    static let cornerRadius: CGFloat = 16
    /// Default middle corner radius for views and buttons
    static let cornerRadiusMiddle: CGFloat = 32
    /// Default button height
    static let buttonHeight: CGFloat = 50
    /// Default animation duration
    static let animationTime: TimeInterval = 0.5
    
    static let imageContainerSize: CGFloat = 66
    
    static let iconSize: CGSize = CGSize(width: 24, height: 24)
}

extension UIConstants {
    static let throttle: DispatchTimeInterval = .milliseconds(300)
}
