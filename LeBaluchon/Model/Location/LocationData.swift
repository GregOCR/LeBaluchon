//
//  LocationData.swift
//  LeBaluchon
//
//  Created by Greg on 11/09/2021.
//

import Foundation

class LocationData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: Sys
}
