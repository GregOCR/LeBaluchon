//
//  WeatherData.swift
//  LeBaluchon
//
//  Created by Greg on 09/09/2021.
//

import Foundation

class WeatherData: Codable {
    let cityName: String
    let currentTime: Int
    let furtherInfos: FurtherInfos
    let weather: [Weather]
    let system: System
    let timeZone: Int
    
    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case currentTime = "dt"
        case furtherInfos = "main"
        case weather = "weather"
        case system = "sys"
        case timeZone = "timezone"
    }
}

class FurtherInfos: Codable {
    let temperature: Double
    let temperatureMin: Double
    let temperatureMax: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
}

class Weather: Codable {
    let typeCode: Int
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case typeCode = "id"
        case description = "description"
    }
}

class System: Codable {
    let countryIsoCode: String
    let sunriseTime: Int
    let sunsetTime: Int
    
    enum CodingKeys: String, CodingKey {
        case countryIsoCode = "country"
        case sunriseTime = "sunrise"
        case sunsetTime = "sunset"
    }
}
