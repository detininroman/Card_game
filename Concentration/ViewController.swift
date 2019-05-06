//
//  ViewController.swift
//  Concentration
//
//  Created by Roman on 01/05/2019.
//  Copyright © 2019 Roman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    private lazy var theme = themes[Int(arc4random_uniform(UInt32(themes.count)))]
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card is not in cardButtons!")
        }
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        for item in emoji {
            theme.emojis.append(emoji.removeValue(forKey: item.key) ?? "?")
        }
        
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        theme = themes[Int(arc4random_uniform(UInt32(themes.count)))]
        
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
            if game.isFinished() {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            }
            
        }
    }

    private var emoji = [Int:String]()

    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, theme.emojis.count  > 0 {
            emoji[card.identifier] = theme.emojis.remove(at: theme.emojis.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    struct Theme {
        var name: String
        var emojis: [String]
    }
    
    private var themes: [Theme] = [
        Theme(name: "Sport",
              emojis: ["⚽", "🏀", "⚾", "🥎", "🎾", "🏐",
                       "🎱", "🏓", "🏒", "🥅", "⛳", "🥊",
                       "🥋", "🛹", "⛸", "🤽‍♂️", "🚣", "🚴"]),
        Theme(name: "Animals",
              emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊",
                       "🐻", "🐼", "🐨", "🐯", "🦁", "🐮",
                       "🐷", "🐸", "🐵", "🐔", "🐧", "🐦"]),
        Theme(name: "Food",
              emojis: ["🍎", "🍐", "🍊", "🍋", "🍌", "🍉",
                       "🍇", "🍓", "🍒", "🍑", "🥭", "🍍",
                       "🥥", "🥝", "🍅", "🍆", "🥒", "🌶"]),
        Theme(name: "Transport",
              emojis: ["🚗", "🚕", "🚙", "🚌", "🏎", "🚓",
                       "🚒", "🚐", "🚚", "🚜", "🛴", "🚲",
                       "🛵", "🏍", "🚔", "🚖", "🚄", "🛩"]),
        Theme(name: "Objects",
              emojis: ["⌚", "📱", "💻", "💿", "📞", "📺",
                       "🎙", "🧭", "⏰", "💵", "💳", "💎",
                       "🔨", "🔧", "💊", "🔭", "📏", "🔓"])
        ]
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

