//
//  Set.swift
//  Set
//
//  Created by Ivan Tchernev on 23/01/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation

class Set {
    var unPlayedCards = [Card]()
    var cardsInPlay = [Card]()
    var selectedCards = [Card]()
    var matchedCards = [Card]()
    var score = 0
    
    init() {
        let numberOfVariations = Card.CardProperty.allValues.count
        for i in 0..<numberOfVariations {
            for j in 0..<numberOfVariations {
                for k in 0..<numberOfVariations {
                    for l in 0..<numberOfVariations {
                        unPlayedCards.append(Card(color: Card.CardProperty.allValues[i],
                                                number: Card.CardProperty.allValues[j],
                                                shape: Card.CardProperty.allValues[k],
                                                shading: Card.CardProperty.allValues[l]))
                    }
                }
            }
        }
        
        //Shuffle the cards
        for k in stride(from: cardsInPlay.count - 1, to: 0, by: -1) {
            cardsInPlay.swapAt(Int(arc4random_uniform(UInt32(k + 1))), k)
        }
        
        for _ in 0..<12 {
            cardsInPlay.append(unPlayedCards.popLast()!)
        }
    }
    
    func chooseCard(at index: Int) {
        let selectedCard = cardsInPlay[index]
        if selectedCards.count == 3 {
            if Card.doFormSetOfThree(first: selectedCards[0], second: selectedCards[1], third: selectedCards[2]) {
                score += 3
                
                matchedCards.append(contentsOf: selectedCards)
                cardsInPlay = cardsInPlay.filter { !selectedCards.contains($0) }
                if !unPlayedCards.isEmpty {
                    cardsInPlay.append(contentsOf: unPlayedCards[0..<3])
                    unPlayedCards.removeSubrange(0..<3)
                }
            } else {
                score -= 5
            }
            selectedCards.removeAll()
        }
        if let indexOfPreviouslySelectedCard = selectedCards.index(of: selectedCard) {
            selectedCards.remove(at: indexOfPreviouslySelectedCard)
        } else {
            selectedCards.append(selectedCard)
        }
    }
}
