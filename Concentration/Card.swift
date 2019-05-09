//
//  Card.swift
//  Concentration
//
//  Created by Roman on 02/05/2019.
//  Copyright © 2019 Roman. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory;
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
