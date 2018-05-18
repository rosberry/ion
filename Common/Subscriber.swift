//
//  Subscriber.swift
//  Ion
//
//  Created by Anton K on 7/27/17.
//

public class Subscriber<T> {
    let match: (T) -> Bool
    let transform: (T) -> (T)

    public typealias Handler = (T) -> Void
    public let handler: Handler

    public init<M: Matcher>(_ matcher: M, handler: @escaping Handler) where M.T == T {
        self.match = matcher.match
        self.transform = matcher.transform

        self.handler = handler
    }

    func emitUpdate(_ object: T) {
        handler(transform(object))
    }
}

// MARK: - Equatable

extension Subscriber: Equatable {
    public static func == (lhs: Subscriber, rhs: Subscriber) -> Bool {
        return lhs === rhs
    }
}
