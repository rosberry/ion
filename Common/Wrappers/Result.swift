//
//  Result.swift
//  Ion
//
//  Created by Anton K on 3/29/18.
//

public enum ResultType {
    case success
    case failure
}

public protocol ResultProtocol: Equatable {
    associatedtype T

    var type: ResultType { get }
    var content: T? { get }
    var error: Error? { get }
}

// MARK: - Result

public enum Result<Value>: ResultProtocol {
    public typealias T = Value

    case success(Value)
    case failure(Error)

    public var type: ResultType {
        switch self {
        case .success:
            return .success
        case .failure:
            return .failure
        }
    }

    public var content: T? {
        if case let .success(value) = self {
            return value
        }

        return nil
    }

    public var error: Error? {
        if case let .failure(error) = self {
            return error
        }

        return nil
    }
}

extension Result: Equatable {
    public static func == (lhs: Result, rhs: Result) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }
}

extension Result where Value: Equatable {
    public static func == (lhs: Result, rhs: Result) -> Bool {
        switch (lhs, rhs) {
        case let (.success(lContent), .success(rContent)):
            return lContent == rContent
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }

    public static func != (lhs: Result, rhs: Result) -> Bool {
        return !(lhs == rhs)
    }
}
