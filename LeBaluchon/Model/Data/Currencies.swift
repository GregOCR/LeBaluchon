//
//  Currencies.swift
//  LeBaluchon
//
//  Created by Greg on 14/09/2021.
//

import Foundation

struct Currencies {
    
    static var shared = Currencies()
    
//    var date = String()
    var date = "dateManager.getFormattedDate(.CurrentUTCTime)"    
    var entries: [Currency] = [
        .init(isoCode: "EUR", isoSymbol: "€€€", description: "Euro", rate: 1.0),
        .init(isoCode: "USD", isoSymbol: "$$$", description: "Dollar Américain", rate: 1.159051),
        .init(isoCode: "GBP", isoSymbol: "£££", description: "Livre Sterling", rate: 0.848367),
        .init(isoCode: "YEN", isoSymbol: "¥¥¥", description: "Yen Chinoise", rate: 131.563266),
        .init(isoCode: "", isoSymbol: "－－－", description: "", rate: 0),
        .init(isoCode: "CAD", isoSymbol: "", description: "Dollar Canadien", rate: 1.441221),
        .init(isoCode: "AED", isoSymbol: "", description: "Dirham Des Émirats Arabes Unis", rate: 4.273157),
        .init(isoCode: "TRY", isoSymbol: "", description: "Lire Turque", rate: 10.642451)
    ]
}
