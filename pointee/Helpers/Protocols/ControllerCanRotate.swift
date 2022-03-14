//
//  ControllerCanRotate.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/// Controller Can Rotate, should be presented Full Screen
protocol ControllerCanRotate {
    /// Change it to true, when we need to restore default Device orientation
    var changeToDefaultOrientation: Bool { get }
}
