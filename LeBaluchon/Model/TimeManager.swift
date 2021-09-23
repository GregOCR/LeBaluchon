//
//  TimeBuilder.swift
//  LeBaluchon
//
//  Created by Greg on 09/09/2021.
//

import Foundation

struct TimeManager {
    
    static func getTimeFromUnixTimestamp(_ unixTimestamp: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixTimestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date as Date).replacingOccurrences(of: ":", with: "h")
    }
}
