//
//  Date+Components.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/**
    Extension for Date object
 */
extension Date {
    
    /// Format Date in hours and minutes format - 12:00
    var hourAndMinuteString: String {
        let (hour, minute) = hourAndMinute
        return String(format: "%02d:%02d", hour, minute)
    }
    
    /// Format Date to hour and minute format tuple - (hour: 12, minute: 00)
    var hourAndMinute: (hour: Int, minute: Int) {
        let comp = Calendar.current.dateComponents([.hour, .minute], from: self)
        guard let hour = comp.hour, let minute = comp.minute else {
            return (hour: 0, minute: 0)
        }
        return (hour: hour, minute: minute)
    }
    
    /// Get DayInWeek from current Date
    var weekday: DayInWeek? {
        let components = Calendar.current.dateComponents([.weekday], from: self)
        guard let weekday = components.weekday, let day = DayInWeek(rawValue: weekday) else {
            return nil
        }
        return day
    }
    
    var isToday: Bool {
        let this = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return this.year == today.year && this.month == today.month && this.day == today.day
    }
    
    var isTomorrow: Bool {
        let this = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        guard let day = today.day else { return false }
        return this.year == today.year && this.month == today.month && this.day == day + 1
    }
    
    /// Format TimeInterval for Current Date
    /// - Parameters:
    ///   - days: Int
    ///   - hours: Int
    ///   - seconds: Int
    static func timeIntervalFor(days: Int, hours: Int = 0, seconds: Int = 0) -> TimeInterval {
        let secondsPerHour = 3600
        let hoursPerDay = 24
        return TimeInterval(days * hoursPerDay * secondsPerHour + hours * secondsPerHour + seconds)
    }
    
    /// Format Date to ISO8601 String
    /// - Parameter timeZone: TimeZone
    func toISO8601String(timeZone: TimeZone? = TimeZone.init(secondsFromGMT: 0)) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
    
    /// Format Date to Pretty String
    func toPrettyString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}
