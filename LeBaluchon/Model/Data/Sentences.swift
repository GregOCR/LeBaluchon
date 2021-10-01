//
//  Sentences.swift
//  LeBaluchon
//
//  Created by Greg on 01/10/2021.
//

import Foundation

struct Sentences {
    
    static var shared = Sentences()
    
    var entries: [Sentence] = [
        .init(content: "Bonjour"),
        .init(content: "Aurevoir"),
        .init(content: "Pouvez-vous m'indiquer le chemin pour la gare, s'il-vous-plait ?"),
        .init(content: "J'ai besoin d'une bouteille d'eau, s'il-vous-plait.")
    ]
}
