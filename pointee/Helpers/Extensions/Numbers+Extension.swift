//
//  Int+Extension.swift
//  pointee
//
//  Created by Alexander on 26.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

extension Int {

    func shortCount() -> String {
        if self < 1000 {
            return String(self)
        } else {
            return R.string.localizable.kilo(String(format: "%.01f", Float(self) / 1000))
        }
    }
}

extension Float {

    func shortCount() -> String {
        if self < 1000 {
            return String(self)
        } else {
            return R.string.localizable.kilo(String(format: "%.01f", self / 1000))
        }
    }
    
    func priceString() -> String {
        return String(format: "%.2f", self)
    }
}

extension Double {

    func shortDistance() -> String {
        if self < 1000 {
            return R.string.localizable.short_meters(String(Int(self)))
        } else {
            return R.string.localizable.km(String(format: "%.01f", self / 1000))
        }
    }
}
