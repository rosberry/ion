//
//  EventSource.swift
//  Ion
//
//  Created by Anton K on 1/31/18.
//

public protocol EventSource {
    associatedtype T

    func subscribe<M: Matcher>(_ matcher: M, handler: @escaping (T) -> Void) -> Subscriber<T> where M.T == T
    @discardableResult func subscribe(_ subscriber: Subscriber<T>) -> Subscriber<T>

    func unsubscribe(_ subscriber: Subscriber<T>)
    func resubscribe(_ subscriber: Subscriber<T>)
}

// MARK: - Type Eraser

private class EventSourceBaseImpl<T>: EventSource {
    func subscribe<M: Matcher>(_ matcher: M, handler: @escaping (T) -> Void) -> Subscriber<T> where M.T == T {
        fatalError()
    }

    @discardableResult
    func subscribe(_ subscriber: Subscriber<T>) -> Subscriber<T> {
        fatalError()
    }

    func unsubscribe(_ subscriber: Subscriber<T>) {}
    func resubscribe(_ subscriber: Subscriber<T>) {}
}

final private class EventSourceWrapper<E: EventSource>: EventSourceBaseImpl<E.T> {
    private let source: E
    
    public init(_ source: E) {
        self.source = source
    }

    public override func subscribe<M: Matcher>(_ matcher: M, handler: @escaping (E.T) -> Void) -> Subscriber<T> where M.T == E.T {
        return source.subscribe(matcher, handler: handler)
    }

    @discardableResult
    public override func subscribe(_ subscriber: Subscriber<E.T>) -> Subscriber<E.T> {
        return source.subscribe(subscriber)
    }

    public override func unsubscribe(_ subscriber: Subscriber<E.T>) {
        source.unsubscribe(subscriber)
    }

    public override func resubscribe(_ subscriber: Subscriber<E.T>) {
        source.resubscribe(subscriber)
    }
}

public struct AnyEventSource<T>: EventSource {
    private let base: EventSourceBaseImpl<T>

    public init<E: EventSource>(_ base: E) where E.T == T {
        self.base = EventSourceWrapper(base)
    }

    public func subscribe<M: Matcher>(_ matcher: M, handler: @escaping (T) -> Void) -> Subscriber<T> where M.T == T {
        return base.subscribe(matcher, handler: handler)
    }

    @discardableResult
    public func subscribe(_ subscriber: Subscriber<T>) -> Subscriber<T> {
        return base.subscribe(subscriber)
    }

    public func unsubscribe(_ subscriber: Subscriber<T>) {
        base.unsubscribe(subscriber)
    }

    public func resubscribe(_ subscriber: Subscriber<T>) {
        base.resubscribe(subscriber)
    }
}
