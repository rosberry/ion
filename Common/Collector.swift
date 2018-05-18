//
//  Collector.swift
//  Ion
//
//  Created by Anton K on 2/16/18.
//

public class Collector<T> {
    private var subscribers: [WeakRef<Subscriber<T>>] = []
    let source: AnyEventSource<T>

    public init<E: EventSource>(source: E) where E.T == T {
        if let typeErasedSource = source as? AnyEventSource<T> {
            self.source = typeErasedSource
        }
        else {
            self.source = AnyEventSource(source)
        }
    }

    deinit {
        unsubscribe()
    }

    public func forEach(_ handler: (Subscriber<T>) -> (Void)) {
        subscribers.compact()
        for subscriber in subscribers.strongReferences {
            handler(subscriber)
        }
    }

    @discardableResult
    public func add(_ subscriber: Subscriber<T>) -> Subscriber<T> {
        source.subscribe(subscriber)
        subscribers.append(weak: subscriber)
        return subscriber
    }

    public func subscribe<M: Matcher>(_ matcher: M, handler: @escaping (T) -> Void) where M.T == T {
        add(Subscriber(matcher, handler: handler))
    }

    public func resubscribe() {
        forEach { (subscriber: Subscriber<T>) in
            source.resubscribe(subscriber)
        }
    }

    public func unsubscribe() {
        forEach { (subscriber: Subscriber<T>) in
            source.unsubscribe(subscriber)
        }
    }

    public func unsubscribe(_ target: Subscriber<T>) {
        source.unsubscribe(target)
        subscribers.remove(target)
    }
}

// MARK: - General Helpers

extension Collector {

    @discardableResult
    public func subscribe(_ closure: @escaping (T) -> (Bool), handler: @escaping (T) -> Void) -> Subscriber<T> {
        let matcher = ClosureMatcher(closure: closure)
        return add(source.subscribe(matcher, handler: handler))
    }

    @discardableResult
    public func subscribe<V: Equatable>(_ keyPath: KeyPath<T, V>, value: V, handler: @escaping (T) -> Void) -> Subscriber<T> {
        let matcher = PropertyMatcher(keyPath: keyPath, value: value)
        return add(source.subscribe(matcher, handler: handler))
    }

    @discardableResult
    public func subscribe(handler: @escaping (T) -> Void) -> Subscriber<T> {
        let matcher = AnyMatcher<T>()
        return add(source.subscribe(matcher, handler: handler))
    }
}

// MARK: - Equatable Helpers

extension Collector where T: Equatable {
    @discardableResult
    public func subscribe(_ value: T, handler: @escaping (T) -> Void) -> Subscriber<T> {
        let matcher = ObjectMatcher(object: value)
        return add(source.subscribe(matcher, handler: handler))
    }
}

// MARK: - Result Helpers

extension Collector where T: ResultProtocol {
    @discardableResult
    public func subscribe(_ type: ResultType, handler: @escaping (T) -> Void) -> Subscriber<T> {
        let matcher = ResultMatcher<T>(type: type)
        return add(source.subscribe(matcher, handler: handler))
    }

    @discardableResult
    public func subscribeSuccess(handler: @escaping (T.T) -> Void) -> Subscriber<T> {
        return subscribe(.success, handler: { (result: T) in
            if let content = result.content {
                handler(content)
            }
        })
    }

    @discardableResult
    public func subscribeFailure(handler: @escaping (Error) -> Void) -> Subscriber<T> {
        return subscribe(.failure, handler: { (result: T) in
            if let error = result.error {
                handler(error)
            }
        })
    }
}
