//
//  Currencies.swift
//  LeBaluchon
//
//  Created by Greg on 14/09/2021.
//

import Foundation

struct Currencies {
    
    static var shared = Currencies()
    
    var date = String()
    var currentCountryCurrency: Currency = .init(isoCode: "EUR", description: "Euro", dayRate: 1.0, isoCodeUsers: [""])
    
    var entries: [Currency] = [
        .init(isoCode: "📍", description: "", dayRate: 0.0, isoCodeUsers: [""]),
        .init(isoCode: "€€€", description: "Euro", dayRate: 1.0, isoCodeUsers: [""]),
        .init(isoCode: "$$$", description: "Dollar Américain", dayRate: 1.159051, isoCodeUsers: [""]),
        .init(isoCode: "£££", description: "Livre Sterling", dayRate: 0.848367, isoCodeUsers: [""]),
        .init(isoCode: "¥¥¥", description: "Yen Chinoise", dayRate: 131.563266, isoCodeUsers: [""]),
        .init(isoCode: "－－－", description: "", dayRate: 0.0, isoCodeUsers: [""]),
        .init(isoCode: "CAD", description: "Dollar Canadien", dayRate: 1.441221, isoCodeUsers: [""])
    ]
}
