//
//  UIDevice+Extension.swift
//  pointee
//
//  Created by Alexander on 26.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit

extension UIDevice {

    var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}
