//
//  Matcher.swift
//  Ion
//
//  Created by Anton K on 2/16/18.
//

// MARK: Matcher

public protocol Matcher {
    associatedtype T

    func match(_ object: T) -> Bool
    func transform(_ object: T) -> T
}

extension Matcher {
    public func match(_ object: T) -> Bool {
        return true
    }

    public func transform(_ object: T) -> T {
        return object
    }
}

// MARK: - AnyMatcher

final public class AnyMatcher<T>: Matcher {
    public init() {}
    public func match(_ object: T) -> Bool {
        return true
    }
}

// MARK: - ObjectMatcher

final public class ObjectMatcher<T: Equatable>: Matcher {
    public let object: T

    public init(object: T) {
        self.object = object
    }

    public func match(_ object: T) -> Bool {
        return self.object == object
    }
}

// MARK: - PropertyMatcher

final public class PropertyMatcher<T, V: Equatable>: Matcher {
    public let keyPath: KeyPath<T, V>
    public var value: V

    public init(keyPath: KeyPath<T, V>, value: V) {
        self.keyPath = keyPath
        self.value = value
    }

    public func match(_ object: T) -> Bool {
        return object[keyPath: keyPath] == value
    }
}

// MARK: - ClosureMatcher

final public class ClosureMatcher<T>: Matcher {
    public let closure: (T) -> (Bool)

    public init(closure: @escaping (T) -> (Bool)) {
        self.closure = closure
    }

    public func match(_ object: T) -> Bool {
        return closure(object)
    }
}

// MARK: - TrainMatcher

final public class TrainMatcher<T: Train>: Matcher {
    private let elementMatch: (T.Element) -> (Bool)
    private let elementTransform: (T.Element) -> (T.Element)

    public init<M: Matcher>(elementMatcher: M) where M.T == T.Element {
        self.elementMatch = elementMatcher.match
        self.elementTransform = elementMatcher.transform
    }

    public func transform(_ object: T) -> T {
        return object.filter(elementMatch).transform(elementTransform)
    }
}

public protocol Train: MutableCollection, ExpressibleByArrayLiteral, CustomStringConvertible {
    func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> Self
    func transform(_ transform: (Element) throws -> Element) rethrows -> Self
}

extension Array: Train {
    public func transform(_ transform: (Element) throws -> Element) rethrows -> [Element] {
        return try map({ (element: Element) -> Element in
            return try transform(element)
        })
    }
}

// MARK: - ResultMatcher

final public class ResultMatcher<T: ResultProtocol>: Matcher {
    let type: ResultType

    public static var success: ResultMatcher<T> {
        return ResultMatcher<T>(type: .success)
    }

    public static var failure: ResultMatcher<T> {
        return ResultMatcher<T>(type: .failure)
    }

    public init(type: ResultType) {
        self.type = type
    }

    public func match(_ object: T) -> Bool {
        return object.type == type
    }
}
