//
//  EventSink.swift
//  Ion
//
//  Created by Anton K on 1/31/18.
//

public protocol EventSink {
    associatedtype T

    func emit(_ value: T)
    func replace(_ value: T)

    func discard()
    func discard(_ value: T)
}

// MARK: - Type Eraser

private class EventSinkBaseImpl<T>: EventSink {
    func emit(_ value: T) {}
    func replace(_ value: T) {}
    func discard() {}
    func discard(_ value: T) {}
}

final private class EventSinkWrapper<E: EventSink>: EventSinkBaseImpl<E.T> {
    private let sink: E

    public init(_ sink: E) {
        self.sink = sink
    }

    public override func emit(_ value: E.T) {
        sink.emit(value)
    }

    public override func replace(_ value: E.T) {
        sink.replace(value)
    }

    public override func discard(_ value: E.T) {
        sink.discard(value)
    }

    public override func discard() {
        sink.discard()
    }
}

public struct AnyEventSink<T>: EventSink {
    private let base: EventSinkBaseImpl<T>

    public init<E: EventSink>(_ base: E) where E.T == T {
        self.base = EventSinkWrapper(base)
    }

    public func emit(_ value: T) {
        base.emit(value)
    }

    public func replace(_ value: T) {
        base.replace(value)
    }

    public func discard(_ value: T) {
        base.discard(value)
    }

    public func discard() {
        base.discard()
    }
}
