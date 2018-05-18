//
//  Service.swift
//  Ion
//
//  Created by Anton K on 7/27/17.
//

open class Emitter<T>: EventSink, EventSource {
    public private(set) var subscribers: [Subscriber<T>] = []
    public private(set) var values: [T] = []
    public var valueStackDepth: Int = .max

    public init() {}

    // MARK: - EventSource

    public func subscribe<M: Matcher>(_ matcher: M, handler: @escaping (T) -> Void) -> Subscriber<T> where M.T == T {
        return subscribe(Subscriber(matcher, handler: handler))
    }

    @discardableResult
    public func subscribe(_ subscriber: Subscriber<T>) -> Subscriber<T> {
        if subscribers.index(of: subscriber) == nil {
            subscribers.append(subscriber)

            for value in values where subscriber.match(value) {
                subscriber.emitUpdate(value)
            }
        }

        return subscriber
    }

    public func unsubscribe(_ subscriber: Subscriber<T>) {
        if let index = subscribers.index(of: subscriber) {
            subscribers.remove(at: index)
        }
    }

    public func resubscribe(_ subscriber: Subscriber<T>) {
        unsubscribe(subscriber)
        subscribe(subscriber)
    }

    // MARK: - EventSink

    private func propagate(_ value: T) {
        values.append(value)

        for subscriber in subscribers where subscriber.match(value) {
            subscriber.emitUpdate(value)
        }

        if values.count > valueStackDepth {
            values.removeFirst(values.count - valueStackDepth)
        }
    }

    public func emit(_ value: T) {
        discard()
        propagate(value)
    }

    public func replace(_ value: T) {
        discard()
        propagate(value)
    }

    public func discard(_ value: T) {
        discard()
    }

    public func discard() {
        values.removeAll()
    }
}

// MARK: - T: Equatable

extension Emitter where T: Equatable {
    public func emit(_ value: T) {
        discard(value)
        propagate(value)
    }

    public func discard(_ value: T) {
        if let index = values.index(of: value) {
            values.remove(at: index)
        }
    }
}
