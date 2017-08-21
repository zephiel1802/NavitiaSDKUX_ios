//
//  Metrics.swift
//  RenderTest
//
//  Created by Thomas Noury on 02/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation

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

func durationText(seconds: Int32) -> String {
    if (seconds < 60) {
        return "< 1 min"
    } else if (seconds < 3600) {
        let minutes: Int32 = seconds / 60
        return String(minutes) + " min"
    } else {
        let hours: Int32 = seconds / 3600
        let remainingMinutes: Int32 = (seconds / 60) - (hours * 60)
        return String(hours) + "h" + String(remainingMinutes)
    }
}

func distanceText(meters: Int32) -> String {
    if (meters < 1000) {
        return String(meters) + "m"
    } else {
        return String(Float(meters) / 1000) + " km"
    }
}
