//
//  WorkingDay.swift
//  pointee
//
//  Created by Alexander on 24.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

struct WorkingDay: Codable {
    let day: Int
    let allDay: Bool
    let openTime: Date?
    let closeTime: Date?
    let breakTime: Date?
    let breakDuration: Float?
    
    enum CodingKeys: String, CodingKey {
        case day
        case allDay = "all_day"
        case openTime = "open_time"
        case closeTime = "close_time"
        case breakTime = "break_time"
        case breakDuration = "break_duration"
    }
}
