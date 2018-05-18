//
//  Character.swift
//  Ion iOS Example
//
//  Created by Anton K on 3/23/18.
//

import Foundation

class Character {
    enum Source {
        case book(String)
        case animation(String)
        case liveAction(String)
        case game(String)
    }

    var name: String
    var source: Source

    init(name: String, source: Source) {
        self.name = name
        self.source = source
    }
}

extension Character: Equatable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        return (lhs.name == rhs.name)
    }
}

extension Character: CustomStringConvertible {
    var description: String {
        return name
    }
}
