//
//  Cities.swift
//  LeBaluchon
//
//  Created by Greg on 01/10/2021.
//

import Foundation

struct Cities {
    
    static var shared = Cities()
    
    var entries: [City] = [
        .init(name: "Paris", countryIsoCode: "FR", longitude: 2.3488, latitude: 48.8534),
        .init(name: "New York", countryIsoCode: "US", longitude: -74.006, latitude: 40.7143),
        .init(name: "Strasbourg", countryIsoCode: "FR", longitude: 7.743, latitude: 48.5834),
        .init(name: "Marseille", countryIsoCode: "FR", longitude: 5.221920, latitude: 43.1742)
    ]
}
