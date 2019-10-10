//
//  Logger.swift
//  Ion
//
//  Created by Anton K on 09/10/2019.
//

final public class Logger<T>: EmitterDelegate {

    public var name: String?
    public var isEnabled: Bool = true
    weak var target: EmitterDelegate?

    public init() {}

    private func pointer(to object: AnyObject) -> String {
        return "\(Unmanaged.passUnretained(object).toOpaque())"
    }

    public func emitter<T>(_ sender: Emitter<T>, didRegister subscriber: Subscriber<T>) {
        if isEnabled {
            print("[II] E[\(name ?? pointer(to: sender))] didRegister: \(pointer(to: subscriber))")
        }
        target?.emitter(sender, didRegister: subscriber)
    }

    public func emitter<T>(_ sender: Emitter<T>, didUnregister subscriber: Subscriber<T>) {
        if isEnabled {
            print("[II] E[\(name ?? pointer(to: sender))] didUnregister: \(pointer(to: subscriber))")
        }
        target?.emitter(sender, didUnregister: subscriber)
    }

    public func emitter<T>(_ sender: Emitter<T>, willEmit value: T) {
        if isEnabled {
            print("[II] E[\(name ?? pointer(to: sender))] willEmit: \(value)")
        }
        target?.emitter(sender, willEmit: value)
    }

    public func emitter<T>(_ sender: Emitter<T>, willReplace value: T) {
        if isEnabled {
            print("[II] E[\(name ?? pointer(to: sender))] willReplace: \(value)")
        }
        target?.emitter(sender, willReplace: value)
    }

    public func emitter<T>(_ sender: Emitter<T>, didPropagate value: T, to subscriber: Subscriber<T>) {
        if isEnabled {
            print("[II] E[\(name ?? pointer(to: sender))] didPropagate: \(value) to: \(pointer(to: subscriber))")
        }
        target?.emitter(sender, didPropagate: value, to: subscriber)
    }

    public func emitter<T>(_ sender: Emitter<T>, didDiscard value: T) {
        if isEnabled {
            print("[II] E[\(name ?? pointer(to: sender))] didDiscard: \(value)")
        }
        target?.emitter(sender, didDiscard: value)
    }
}

