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
    
    func refreshDate() -> String {
        return getFormattedDate(.FullCurrentDate).uppercased()
    }
    
    // get date as String
    private func getDate(withDateStyle dateStyle: DateFormatter.Style, withTimeStyle timeStyle: DateFormatter.Style) -> String {
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.locale = Locale(identifier: "fr")
        
        return dateFormatter.string(from: date)
    }
    // get formatted date information
    private func getFormattedDate(_ dateType: DateType) -> String {
        var dateStyle: DateFormatter.Style = .short
        var timeStyle: DateFormatter.Style = .none
        
        switch dateType {
        case .FullCurrentDate:
            dateStyle = .full
        case .CurrentUTCTime:
            timeStyle = .long
        }
        
        let date = self.getDate(withDateStyle: dateStyle, withTimeStyle: timeStyle)
        
        return String(date).uppercased()
    }
}
