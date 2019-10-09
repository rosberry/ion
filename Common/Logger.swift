//
//  Logger.swift
//  Ion
//
//  Created by Anton K on 09/10/2019.
//

final public class Logger<T>: EmitterDelegate {

    public init() {}

    private func pointer(to object: AnyObject) -> UnsafeMutableRawPointer {
        return Unmanaged.passUnretained(object).toOpaque()
    }

    public func emitter<T>(_ sender: Emitter<T>, didRegister subscriber: Subscriber<T>) {
        print("[II] E[\(pointer(to: sender))] didRegister: \(pointer(to: subscriber))")
    }

    public func emitter<T>(_ sender: Emitter<T>, didUnregister subscriber: Subscriber<T>) {
        print("[II] E[\(pointer(to: sender))] didUnregister: \(pointer(to: subscriber))")
    }

    public func emitter<T>(_ sender: Emitter<T>, willEmit value: T) {
        print("[II] E[\(pointer(to: sender))] willEmit: \(value)")
    }

    public func emitter<T>(_ sender: Emitter<T>, willReplace value: T) {
        print("[II] E[\(pointer(to: sender))] willReplace: \(value)")
    }

    public func emitter<T>(_ sender: Emitter<T>, didPropagate value: T, to subscriber: Subscriber<T>) {
        print("[II] E[\(pointer(to: sender))] didPropagate: \(value) to: \(pointer(to: subscriber))")
    }

    public func emitter<T>(_ sender: Emitter<T>, didDiscard value: T) {
        print("[II] E[\(pointer(to: sender))] didDiscard: \(value)")
    }
}

