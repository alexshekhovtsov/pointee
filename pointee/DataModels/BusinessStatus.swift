//
//  BusinessStatus.swift
//  pointee
//
//  Created by Alexander on 24.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

enum BusinessStatus: String, CodingKey, Codable {
    case open
    case closed
    case technicalBreak = "technical_break"
}

extension BusinessStatus {
    var toString: String {
        switch self {
        case .open:
            return R.string.localizable.open()
        case .closed:
            return R.string.localizable.closed()
        case .technicalBreak:
            return R.string.localizable.tech_break()
        }
    }
}
