//
//  String+Extensions.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

extension String {
    
    internal func date(withFormat format: String, timeZone: TimeZone? = nil) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        return formatter.date(from: self)
    }
    
    func ISO8601Date(timeZone: TimeZone? = TimeZone.current) -> Date? {
        
        if let result = date(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", timeZone: timeZone) {
            return result
        }
        
        return date(withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'", timeZone: timeZone)
    }
}
