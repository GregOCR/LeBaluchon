//
//  WeatherData.swift
//  LeBaluchon
//
//  Created by Greg on 09/09/2021.
//

import Foundation

class WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: Sys
    let timezone: Int
}

class Main: Codable {
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
    let id: Int
    let description: String
}

class Sys: Codable {
    let country: String
    let sunrise: Int
    let sunset: Int
}
