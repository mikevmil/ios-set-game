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
    var isComplete: Bool {
        return matchedCards.count == Int(pow(Double(Card.CardProperty.allValues.count), 4.0))
    }
    
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
        
        unPlayedCards = shuffleCards(inArray: unPlayedCards)
        
        drawMultipleCards(number: 12)
    }
    
    private func shuffleCards(inArray cards: [Card]) -> [Card]{
        var shuffledCards = cards
        for k in stride(from: cards.count - 1, to: 0, by: -1) {
            shuffledCards.swapAt(Int(arc4random_uniform(UInt32(k + 1))), k)
        }
        return shuffledCards
    }
    
    func shuffleCardsInPlay() {
        cardsInPlay = shuffleCards(inArray: cardsInPlay)
    }
    
    func chooseCard(_ card: Card) {
        var indexOfPreviouslySelectedCard = selectedCards.index(of: card)
        
        if selectedCards.count == 3 {
            indexOfPreviouslySelectedCard = nil
            selectedCards.removeAll()
        } else if selectedCards.count == 2 {
            //score successful and unsuccessful matches
            if Card.doFormSetOfThree(first: selectedCards[0], second: selectedCards[1], third: card) {
                score += 3
                let newMatchedCards = [selectedCards[0], selectedCards[1], card]
                
                matchedCards.append(contentsOf: newMatchedCards)
                for matchedCard in newMatchedCards {
                    let inPlayIndex = cardsInPlay.index(of: matchedCard)
                    if let index = inPlayIndex {
                        if !unPlayedCards.isEmpty {
                            cardsInPlay[index] = unPlayedCards.popLast()!
                        } else {
                            cardsInPlay.remove(at: index)
                        }
                    }
                }
                indexOfPreviouslySelectedCard = nil
                selectedCards.removeAll()
            } else {
                score -= 5
            }
        }
        if indexOfPreviouslySelectedCard == nil && !matchedCards.contains(card) {
            selectedCards.append(card)
        } else if let index = indexOfPreviouslySelectedCard {
            selectedCards.remove(at: index)
        }
    }
    
    func chooseCard(at index: Int) {
        if index < cardsInPlay.count {
            let selectedCard = cardsInPlay[index]
            chooseCard(selectedCard)
        }
    }
    
    func drawMultipleCards(number: Int) {
        if !unPlayedCards.isEmpty && unPlayedCards.count >= number {
            cardsInPlay.append(contentsOf: unPlayedCards[0..<number])
            unPlayedCards.removeSubrange(0..<number)
        }
    }
}
