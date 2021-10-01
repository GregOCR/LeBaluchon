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
        .init(name: "Paris", longitude: 2.3488, latitude: 48.8534, country: .init(name: "FRANCE", isoCode: "FR")),
        .init(name: "New York", longitude: -74.006, latitude: 40.7143, country: .init(name: "ÉTATS-UNIS", isoCode: "US")),
        .init(name: "Strasbourg", longitude: 7.743, latitude: 48.5834, country: .init(name: "FRANCE", isoCode: "FR"))    ]
}
