//
//  DateTools.swift
//  LeBaluchon
//
//  Created by Greg on 03/09/2021.
//

import Foundation

enum DateInfo {
    case CurrentDate, CurrentTime, CurrentUTCTime, ShortDatePlus1, ShortDatePlus2, ShortDatePlus3
}

func getTheDate(dayPlus: Int, withDateStyle dateStyle: DateFormatter.Style, withTimeStyle timeStyle: DateFormatter.Style) -> String {
    let interval = 86400 * dayPlus
    
    // Create Date
    let date = Date().addingTimeInterval(TimeInterval(interval))

    // Create date formatter
    let dateFormatter = DateFormatter()
    // Set date/time styles
    dateFormatter.dateStyle = dateStyle
    dateFormatter.timeStyle = timeStyle
    // set locale identifier as FR
    dateFormatter.locale = Locale(identifier: "fr")

    // Convert date format to string
    return dateFormatter.string(from: date)
}

func getDateInformation(_ dateInfo: DateInfo) -> String {
    var dayPlus: Int
    var dateStyle: DateFormatter.Style
    var timeStyle: DateFormatter.Style
    var dropLastChar = 0
    
    switch dateInfo {
    case .CurrentDate:
        dayPlus = 0
        dateStyle = .long
        timeStyle = .none
    case .CurrentTime:
        dayPlus = 0
        dateStyle = .none
        timeStyle = .short
    case .CurrentUTCTime:
        dayPlus = 0
        dateStyle = .short
        timeStyle = .long
    case .ShortDatePlus1:
        dayPlus = 1
        dateStyle = .short
        timeStyle = .none
        dropLastChar = 5
    case .ShortDatePlus2:
        dayPlus = 2
        dateStyle = .short
        timeStyle = .none
        dropLastChar = 5
    case .ShortDatePlus3:
        dayPlus = 3
        dateStyle = .short
        timeStyle = .none
        dropLastChar = 5
    }
    
    let date = getTheDate(dayPlus: dayPlus, withDateStyle: dateStyle, withTimeStyle: timeStyle)
    
    return String(date.dropLast(dropLastChar))
}
