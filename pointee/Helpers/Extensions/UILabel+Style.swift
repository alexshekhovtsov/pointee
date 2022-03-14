//
//  UILabel+Style.swift
//  pointee
//
//  Created by Alexander on 22.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit

/**
   Extension for Configuring App Labels Styles
*/
extension UILabel {
    
    func style(_ style: LabelStyle) {
        switch style {
        case .title(let textColor, let textAlignment, let font, let numberOfLines),
                .subTitle(let textColor, let textAlignment, let font, let numberOfLines),
                .body(let textColor, let textAlignment, let font, let numberOfLines):
            self.textAlignment = textAlignment
            self.numberOfLines = numberOfLines
            self.font = font
            self.adjustsFontSizeToFitWidth = true
            self.textColor = textColor
        }
    }
    
    /// LabelStyle
    ///
    /// - title: Title Style with GreenTextColor, Center TextAlignment, font size 20, 0 number of lines
    /// - subTitle: Sub Title Style with GreenTextColor, Center TextAlignment, font size 14, 0 number of lines
    /// - body: Body Style with GreenTextColor, Center TextAlignment, font size 12, 0 number of lines
    enum LabelStyle {
        case title(textColor: UIColor = UIConstants.SpaceBlue,
                   textAlignment: NSTextAlignment = .center,
                   font: UIFont = .appFont(atSize: 20),
                   numberOfLines: Int = 0)
        case subTitle(textColor: UIColor = UIConstants.SpaceBlue,
                      textAlignment: NSTextAlignment = .center,
                      font: UIFont = .appFont(atSize: 14),
                      numberOfLines: Int = 0)
        case body(textColor: UIColor = UIConstants.SpaceBlue,
                  textAlignment: NSTextAlignment = .center,
                  font: UIFont = .appFontBold(atSize: 13),
                  numberOfLines: Int = 0)
    }
}
