//
//  DateTools.swift
//  LeBaluchon
//
//  Created by Greg on 03/09/2021.
//

import Foundation

class DateManager {
    
    static let shared = DateManager()
    
    enum DateType {
        case FullCurrentDate, CurrentUTCTime
    }

    func getDate(withDateStyle dateStyle: DateFormatter.Style, withTimeStyle timeStyle: DateFormatter.Style) -> String {
        // create the instance of the day to get the date
        let date = Date()
        // create date formatter
        let dateFormatter = DateFormatter()
        // Set date/time styles
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        // set locale identifier as FR
        dateFormatter.locale = Locale(identifier: "fr")
        // convert date format to string format
        return dateFormatter.string(from: date)
    }

    func getDateInformation(_ dateType: DateType) -> String {
        var dateStyle: DateFormatter.Style = .short
        var timeStyle: DateFormatter.Style = .none

        switch dateType {
        case .FullCurrentDate:
            dateStyle = .full
        case .CurrentUTCTime:
            timeStyle = .long
        }
        
        let date = self.getDate(withDateStyle: dateStyle, withTimeStyle: timeStyle)
        
        return String(date)
    }
}
