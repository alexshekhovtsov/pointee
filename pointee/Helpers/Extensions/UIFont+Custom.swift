//
//  UIFont+Custom.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func appFont(atSize: CGFloat) -> UIFont {
        return R.font.evolventaRegular(size: atSize) ?? UIFont.systemFont(ofSize: atSize)
    }
    
    class func appFontBold(atSize: CGFloat) -> UIFont {
        return R.font.evolventaBold(size: atSize) ?? UIFont.systemFont(ofSize: atSize)
    }
}
