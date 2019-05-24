//
//  ViewController.swift
//  Concentration
//
//  Created by Roman on 01/05/2019.
//  Copyright © 2019 Roman. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    lazy var theme: Theme = defaultTheme
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet {
            updateScoreLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card is not in cardButtons!")
        }
    }
    
    func changeTheme(on newThemeName: String)  {
        
        if let index = themes.firstIndex(where: { $0.name == newThemeName }) {
            
            for item in emoji {
                theme.emojis.append(emoji.removeValue(forKey: item.key) ?? "?")
            }
            theme = themes[index]
        }
        updateViewFromModel()
    }
    
    @IBAction private func startNewGame(_ sender: UIButton) {
        
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        changeTheme(on: themes[themes.count.arc4random].name)
    }
    
    private func updateViewFromModel() {
        
        updateFlipCountLabel()
        updateScoreLabel()
        
        if cardButtons == nil {
            return
        }
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0.4219691157, green: 0.639721334, blue: 0.8902803063, alpha: 1)
            }
            if game.isFinished() {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            }
            
        }
    }
    
    private let labelAttributes: [NSAttributedString.Key: Any] = [
        .strokeWidth : -3.0,
        .strokeColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    ]
    
    private func updateFlipCountLabel() {
        if flipCountLabel == nil {
            return
        }
        flipCountLabel.attributedText = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: labelAttributes)
    }
    
    private func updateScoreLabel() {
        if scoreLabel == nil {
            return
        }
        scoreLabel.attributedText = NSAttributedString(string: "Score: \(game.score)", attributes: labelAttributes)
    }

    private var emoji = [Card:String]()

    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, theme.emojis.count  > 0 {
            let randomStringIndex = theme.emojis.index(theme.emojis.startIndex, offsetBy: theme.emojis.count.arc4random)
            emoji[card] = String(theme.emojis.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    struct Theme {
        var name: String
        var emojis: String
    }

    private var defaultTheme = Theme(name: "Default", emojis: "")

    private var themes: [Theme] = [
        Theme(name: "Sport",
              emojis: "⚽🏀⚾🥎🎾🏐🎱🏓🏒🥅⛳🥊🥋🛹⛸🤽‍♂️🚣🚴"),
        Theme(name: "Animals",
              emojis: "🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯🦁🐮🐷🐸🐵🐔🐧🐦"),
        Theme(name: "Food",
              emojis: "🍎🍐🍊🍋🍌🍉🍇🍓🍒🍑🥭🍍🥥🥝🍅🍆🥒🌶"),
        Theme(name: "Transport",
              emojis: "🚗🚕🚙🚌🏎🚓🚒🚐🚚🚜🛴🚲🛵🏍🚔🚖🚄🛩"),
        Theme(name: "Objects",
              emojis: "⌚📱💻💿📞📺🎙🧭⏰💵💳💎🔨🔧💊🔭📏🔓")
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

