//
//  Case.swift
//  Ion
//
//  Created by Anton K on 7/27/17.
//

open class Case<Key: Equatable, Value> {
    public let key: Key
    public var content: Value

    public required init(key: Key, content: Value) {
        self.key = key
        self.content = content
    }
}

extension Case: Equatable {
    public static func == (lhs: Case, rhs: Case) -> Bool {
        return lhs.key == rhs.key
    }
}
