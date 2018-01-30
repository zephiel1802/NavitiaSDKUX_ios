//
//  Metrics.swift
//  RenderTest
//
//  Created by Thomas Noury on 02/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import NavitiaSDK

func timeText(isoString: String) -> String {
    let timeData = isoString.characters.split(separator: "T").map(String.init)
    let hours = String(Array(timeData[1].characters)[0...1])
    let minutes = String(Array(timeData[1].characters)[2...3])
    
    return hours + ":" + minutes
}

func longDateText(datetime: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = config.metrics.longDateFormat
    
    return formatter.string(from: datetime)
}

func getIsoDatetime(datetime: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd'T'HHmmss"
    
    return formatter.string(from: datetime)
}

func durationText(bundle: Bundle, seconds: Int32, useFullFormat: Bool = false) -> String {
    if (seconds < 60) {
        return NSLocalizedString("less_than_a", bundle: bundle, comment: "") + " " + NSLocalizedString("units_minute", bundle: bundle, comment: "Units minute")
    } else if (seconds < 120) {
        return "1 " + NSLocalizedString("units_minute", bundle: bundle, comment: "Units minute")
    } else if (seconds < 3600) {
        let minutes: Int32 = seconds / 60
        return String(minutes) + " " + NSLocalizedString("units_minutes", bundle: bundle, comment: "Units minutes")
    } else {
        let hours: Int32 = seconds / 3600
        let remainingMinutes: Int32 = (seconds / 60) - (hours * 60)
        var minutes: String = String(remainingMinutes)
        if remainingMinutes < 10 {
            minutes = "0" + String(remainingMinutes)
        }
        if useFullFormat {
            if hours > 1 {
                if remainingMinutes > 1 {
                    return String(format:NSLocalizedString("units_hours_and_minutes", bundle: bundle, comment: "Units hours and minutes"), hours, remainingMinutes)
                } else {
                    return String(format:NSLocalizedString("units_hours_and_minute", bundle: bundle, comment: "Units hours and minute"), hours, remainingMinutes)
                }
            } else {
                if remainingMinutes > 1 {
                    return String(format:NSLocalizedString("units_hour_and_minutes", bundle: bundle, comment: "Units hour and minutes"), hours, remainingMinutes)
                } else {
                    return String(format:NSLocalizedString("units_hour_and_minute", bundle: bundle, comment: "Units hour and minute"), hours, remainingMinutes)
                }
            }
        } else {
            return String(hours) + NSLocalizedString("units_h", bundle: bundle, comment: "Units hour abbr") + minutes
        }
    }
}

func distanceText(bundle: Bundle, meters: Int32) -> String {
    if (meters < 1000) {
        return String(meters) + " " + NSLocalizedString("units_meters", bundle: bundle, comment: "Units meters")
    } else {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        let distance: String = formatter.string(for: (Float(meters) / 1000))!
        return distance + " " + NSLocalizedString("units_km", bundle: bundle, comment: "Units km")
    }
}

func sectionLength(paths: [Path]) -> Int32 {
    var distance: Int32 = 0
    for segment in paths {
        distance += segment.length!
    }
    return distance
}
