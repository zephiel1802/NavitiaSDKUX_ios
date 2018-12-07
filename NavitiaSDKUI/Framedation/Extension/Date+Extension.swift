//
//  Date+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        
        return dateFormatter.string(from: self)
    }
    
    func toLocalDate(format: String) -> Date? {
        var dateComponents = Foundation.Calendar.current.dateComponents([.year, .month, .day, .hour, .minute,.second], from: self)
        if let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day, let hour = dateComponents.hour, let minute = dateComponents.minute, let second = dateComponents.second {
            return String(format: "%@%@%@T%@%@%@", year.toDateFormat(), month.toDateFormat(), day.toDateFormat(), hour.toDateFormat(), minute.toDateFormat(), second.toDateFormat()).toDate(format: format)
        }
        
        return self
    }
}

