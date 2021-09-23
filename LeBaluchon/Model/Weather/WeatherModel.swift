//
//  WeatherModel.swift
//  LeBaluchon
//
//  Created by Greg on 09/09/2021.
//

import Foundation

struct WeatherModel {
    
    let cityName: String
    let cityCountryID: String
    let timeZone: Int
    let weatherDescription: String
    let weatherID: Int
    let minTemperature: Double
    let maxTemperature: Double
    let temperature: Double
    let sunriseTime: Int
    let sunsetTime: Int
    let pressure: Int
    let humidity: Int
    
    var weatherCaseStringImageID: String {
        switch self.weatherID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...504:
            return "cloud.sun.rain"
        case 511:
            return "cloud.snow"
        case 520...531:
            return "cloud.rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "wind"
        case 801...804:
            return "cloud"
        default:
            return "sun.max"
        }
    }
    
    var currentDescription: String {
        return weatherDescription.capitalized
    }
    
    var todayMinTemperature: String {
        return String(Int(round(self.minTemperature)))
    }
    
    var todayMaxTemperature: String {
        return String(Int(round(self.maxTemperature)))
    }
    
    var currentTemperature: String {
        return String(Int(round(self.temperature)))
    }
    
    var todaySunriseTime: String {
        return TimeManager.getTimeFromUnixTimestamp(self.sunriseTime+self.timeZone)
    }
    
    var todaySunsetTime: String {
        return TimeManager.getTimeFromUnixTimestamp(self.sunsetTime+self.timeZone)
    }
    
    var todayPressure: String {
        return String(pressure)
    }
    
    var todayHumidity: String {
        return String(humidity)
    }
}
