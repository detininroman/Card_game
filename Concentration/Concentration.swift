//
//  Concentration.swift
//  Concentration
//
//  Created by Roman on 02/05/2019.
//  Copyright © 2019 Roman. All rights reserved.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [Card]()
    
    private(set) var flipCount = 0
    
    private(set) var score = 0
    
    private var matchedCardsAmount = 0
    
    private var flippedCards: Set<Int> = []
    
    private var indexOfOneAndOnlyFacedUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices  {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func isFinished() -> Bool {
        return matchedCardsAmount == cards.count / 2
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        
        if cards[index].isMatched {
            return
        }
        
        flipCount += 1
        
        if let matchIndex = indexOfOneAndOnlyFacedUpCard, matchIndex != index {
            if cards[matchIndex] == cards[index] {
                cards[matchIndex].isMatched = true
                cards[index].isMatched = true
                score += 2
                matchedCardsAmount += 1
            } else {
                if flippedCards.contains(index) {
                    score -= 1
                }
                if flippedCards.contains(matchIndex) {
                    score -= 1
                }
            }
            flippedCards.insert(index)
            flippedCards.insert(matchIndex)
            cards[index].isFaceUp = true
        } else {
            indexOfOneAndOnlyFacedUpCard = index
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(numberOfPairsOfCards: \(numberOfPairsOfCards )): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards.append(card)
            cards.append(card)
        }
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
