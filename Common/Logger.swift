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

    private func pointerString(to object: AnyObject) -> String {
        return "\(Unmanaged.passUnretained(object).toOpaque())"
    }

    private func logIfNeeded<T>(emitter: Emitter<T>, message: String) {
        guard isEnabled else {
            return
        }

        print("[II] E[\(name ?? pointerString(to: emitter))] \(message)")
    }

    public func emitter<T>(_ sender: Emitter<T>, didRegister subscriber: Subscriber<T>) {
        logIfNeeded(emitter: sender, message: "didRegister: \(pointerString(to: subscriber))")
        target?.emitter(sender, didRegister: subscriber)
    }

    public func emitter<T>(_ sender: Emitter<T>, didUnregister subscriber: Subscriber<T>) {
        logIfNeeded(emitter: sender, message: "didUnregister: \(pointerString(to: subscriber))")
        target?.emitter(sender, didUnregister: subscriber)
    }

    public func emitter<T>(_ sender: Emitter<T>, willEmit value: T) {
        logIfNeeded(emitter: sender, message: "willEmit: \(value)")
        target?.emitter(sender, willEmit: value)
    }

    public func emitter<T>(_ sender: Emitter<T>, willReplace value: T) {
        logIfNeeded(emitter: sender, message: "willReplace: \(value)")
        target?.emitter(sender, willReplace: value)
    }

    public func emitter<T>(_ sender: Emitter<T>, didPropagate value: T, to subscriber: Subscriber<T>) {
        logIfNeeded(emitter: sender, message: "didPropagate: \(value) to: \(pointerString(to: subscriber))")
        target?.emitter(sender, didPropagate: value, to: subscriber)
    }

    public func emitter<T>(_ sender: Emitter<T>, didDiscard value: T) {
        logIfNeeded(emitter: sender, message: "didDiscard: \(value)")
        target?.emitter(sender, didDiscard: value)
    }
}

