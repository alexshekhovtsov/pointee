//
//  DayInWeek.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/// WeekDays
typealias WeekDays = Set<DayInWeek>

/**
   DayInWeek Model
*/
enum DayInWeek: Int, Codable {
    case noDaysSet = 0
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

extension DayInWeek {
    
    /// All WeekDays
    static var allDaysInWeek: [DayInWeek] {
        let firstDayOfWeek = NSCalendar.current.firstWeekday
        if firstDayOfWeek == 2 {
            return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        } else if firstDayOfWeek == 1 {
            return [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
        }
        return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    }
    
    /// All Values
    static let allValues: WeekDays = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    
    /// Weekday Values
    static let weekdayValues: WeekDays = [monday, tuesday, wednesday, thursday, friday]
    
    /// Weekend Values
    static let weekendValues: WeekDays = [saturday, sunday]
        
    /// Short Week Day Description
    var short: String {
        switch self {
        case .noDaysSet:
            return "-"
        case .sunday:
            return R.string.localizable.short_sunday()
        case .monday:
            return R.string.localizable.short_monday()
        case .tuesday:
            return R.string.localizable.short_tuesday()
        case .wednesday:
            return R.string.localizable.short_wednesday()
        case .thursday:
            return R.string.localizable.short_thursday()
        case .friday:
            return R.string.localizable.short_friday()
        case .saturday:
            return R.string.localizable.short_saturday()
        }
    }
    
    /// DayInWeek every Weekday Decription
    var name: String {
        switch self {
        case .noDaysSet:
            return ""
        case .monday:
            return R.string.localizable.monday()
        case .tuesday:
            return R.string.localizable.tuesday()
        case .wednesday:
            return R.string.localizable.wednesday()
        case .thursday:
            return R.string.localizable.thursday()
        case .friday:
            return R.string.localizable.friday()
        case .saturday:
            return R.string.localizable.saturday()
        case .sunday:
            return R.string.localizable.sunday()
        }
    }
}
