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
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        for item in emoji {
            emojiChoices.append(emoji.removeValue(forKey: item.key) ?? "?")
        }
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
    
    private var emojiChoices = ["🙈", "🙉", "🙊", "💥", "💦", "💨",
                                "💫", "🐵", "🐒", "🦍", "🐶", "🐕",
                                "🐩", "🐺", "🦊", "🐱", "🐈", "🦁",
                                "🐯", "🐅", "🐆", "🐴", "🐎", "🦄",
                                "🦓", "🐮", "🐂", "🐃", "🐄", "🐷",
                                "🐖", "🐗", "🐽", "🐏", "🐑", "🐐",
                                "🐪", "🐫", "🦒", "🐘", "🦏", "🐭",
                                "🐁", "🐀", "🐹", "🐰", "🐇", "🐿",
                                "🦔", "🦇", "🐻", "🐨", "🐼", "🐾",
                                "🦃", "🐔", "🐓", "🐣", "🐤", "🐥"]

    private var emoji = [Int:String]()

    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count  > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
    }
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

