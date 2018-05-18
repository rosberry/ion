//
//  Service.swift
//  Ion iOS Example
//
//  Created by Anton K on 3/23/18.
//

import Foundation
import Ion

extension Array {
    func random() -> Element {
        let randomIndex = Int(arc4random()) % count
        return self[randomIndex]
    }
}

class Service {

    enum Error: Swift.Error {
        case nope(Character)
    }

    private let characters: [Character] = [
        Character(name: "Monika", source: .game("Doki Doki Literature Club")),
        Character(name: "Dana Zane", source: .game("VA-11 HALL-A")),
        Character(name: "Vincent Vega", source: .liveAction("Pulp Fiction")),
        Character(name: "Mia Wallace", source: .liveAction("Pulp Fiction")),
        Character(name: "Ben Katz", source: .animation("Dr. Katz")),
        Character(name: "Reki", source: .animation("Haibane Renmei")),
        Character(name: "Oedipa Maas", source: .book("The Crying of Lot 49")),
        Character(name: "Aureliano Buendía", source: .book("One Hundred Years of Solitude")),
    ]

    private lazy var singleCharacterEmitter = Emitter<Character>()
    lazy var singleCharacterSource = AnyEventSource(singleCharacterEmitter)

    private lazy var characterListEmitter = Emitter<[Character]>()
    lazy var characterListSource = AnyEventSource(characterListEmitter)

    typealias CharacterResult = Result<Character>
    private lazy var guessResultEmitter = Emitter<CharacterResult>()
    lazy var guessResultSource = AnyEventSource(guessResultEmitter)

    func fetchRandomCharacter() {
        singleCharacterEmitter.emit(characters.random())
    }

    func fetchCharacters() {
        characterListEmitter.replace(characters)
    }

    func guessNextCharacter(name: String) {
        let character = characters.random()
        if character.name == name {
            guessResultEmitter.emit(.success(character))
        }
        else {
            guessResultEmitter.emit(.failure(Error.nope(character)))
        }
    }
}
