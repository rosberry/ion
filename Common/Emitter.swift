//
//  Service.swift
//  Ion
//
//  Created by Anton K on 7/27/17.
//

public protocol EmitterDelegate: class {
    func emitter<T>(_ sender: Emitter<T>, didRegister subscriber: Subscriber<T>)
    func emitter<T>(_ sender: Emitter<T>, didUnregister subscriber: Subscriber<T>)

    func emitter<T>(_ sender: Emitter<T>, willEmit value: T)
    func emitter<T>(_ sender: Emitter<T>, willReplace value: T)
    func emitter<T>(_ sender: Emitter<T>, didPropagate value: T, to subscriber: Subscriber<T>)
    func emitter<T>(_ sender: Emitter<T>, didDiscard value: T)
}

open class Emitter<T>: EventSink, EventSource {
    public private(set) var subscribers: [Subscriber<T>] = []
    public private(set) var values: [T] = []
    public var valueStackDepth: Int

    public weak var delegate: EmitterDelegate? {
        set {
            logger.target = newValue
        }
        get {
            return logger.target
        }
    }

    public private(set) lazy var logger: Logger<T> = {
        let logger = Logger<T>()
        logger.isEnabled = false
        return logger
    }()

    public init(valueStackDepth: Int = .max) {
        self.valueStackDepth = valueStackDepth
    }

    // MARK: - EventSource

    public func subscribe<M: Matcher>(_ matcher: M, handler: @escaping (T) -> Void) -> Subscriber<T> where M.T == T {
        return subscribe(Subscriber(matcher, handler: handler))
    }

    @discardableResult
    public func subscribe(_ subscriber: Subscriber<T>) -> Subscriber<T> {
        if subscribers.index(of: subscriber) == nil {
            subscribers.append(subscriber)
            logger.emitter(self, didRegister: subscriber)

            for value in values where subscriber.match(value) {
                subscriber.emitUpdate(value)
                logger.emitter(self, didPropagate: value, to: subscriber)
            }
        }

        return subscriber
    }

    public func unsubscribe(_ subscriber: Subscriber<T>) {
        if let index = subscribers.index(of: subscriber) {
            subscribers.remove(at: index)
            logger.emitter(self, didUnregister: subscriber)
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
            logger.emitter(self, didPropagate: value, to: subscriber)
        }

        if values.count > valueStackDepth {
            values.removeFirst(values.count - valueStackDepth)
        }
    }

    public func emit(_ value: T) {
        discard()

        logger.emitter(self, willEmit: value)
        propagate(value)
    }

    public func replace(_ value: T) {
        discard()

        logger.emitter(self, willReplace: value)
        propagate(value)
    }

    public func discard(_ value: T) {
        discard()
        logger.emitter(self, didDiscard: value)
    }

    public func discard() {
        values.removeAll()
    }
}

// MARK: - T: Equatable

extension Emitter where T: Equatable {
    public func emit(_ value: T) {
        discard(value)

        logger.emitter(self, willEmit: value)
        propagate(value)
    }

    public func discard(_ value: T) {
        if let index = values.index(of: value) {
            values.remove(at: index)
            logger.emitter(self, didDiscard: value)
        }
    }
}
