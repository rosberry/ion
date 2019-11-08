//
//  Ion_iOSTests.swift
//  Ion iOSTests
//
//  Created by Anton K on 2/21/18.
//

import XCTest
@testable import Ion

class EmitterTests: XCTestCase {

    final class DummyDelegate: EmitterDelegate {

        var registerCallParameters: (sender: AnyObject, subscriber: AnyObject)?
        var unregisterCallParameters: (sender: AnyObject, subscriber: AnyObject)?
        var emitCallParameters: (sender: AnyObject, value: Any)?
        var replaceCallParameters: (sender: AnyObject, value: Any)?
        var propagateCallParameters: (sender: AnyObject, value: Any, subscriber: AnyObject)?
        var discardCallParameters: (sender: AnyObject, value: Any)?

        func emitter<T>(_ sender: Emitter<T>, didRegister subscriber: Subscriber<T>) {
            registerCallParameters = (sender, subscriber)
        }

        func emitter<T>(_ sender: Emitter<T>, didUnregister subscriber: Subscriber<T>) {
            unregisterCallParameters = (sender, subscriber)
        }

        func emitter<T>(_ sender: Emitter<T>, willEmit value: T) {
            emitCallParameters = (sender, value)
        }

        func emitter<T>(_ sender: Emitter<T>, willReplace value: T) {
            replaceCallParameters = (sender, value)
        }

        func emitter<T>(_ sender: Emitter<T>, didPropagate value: T, to subscriber: Subscriber<T>) {
            propagateCallParameters = (sender, value, subscriber)
        }

        func emitter<T>(_ sender: Emitter<T>, didDiscard value: T) {
            discardCallParameters = (sender, value)
        }
    }

    func newAnyEmitter() -> Emitter<Any> {
        return Emitter<Any>()
    }

    func newIntEmitter() -> Emitter<Int> {
        return Emitter<Int>()
    }

    func testAnyEmit() {
        let emitter = newAnyEmitter()
        emitter.emit(0)
        XCTAssert(emitter.values.count == 1)
    }

    func testEquatableEmit() {
        let emitter = newIntEmitter()

        emitter.emit(0)
        XCTAssert(emitter.values == [0])

        emitter.emit(1)
        XCTAssert(emitter.values == [0, 1])
    }

    func testReplace() {
        let emitter = newIntEmitter()

        emitter.replace(0)
        XCTAssert(emitter.values == [0])

        emitter.replace(1)
        XCTAssert(emitter.values == [1])
    }

    func testAnyDiscard() {
        let emitter = newAnyEmitter()
        emitter.emit(0)
        emitter.discard(1)
        XCTAssert(emitter.values.isEmpty)
    }

    func testEquatableDiscard() {
        let emitter = newIntEmitter()

        emitter.emit(0)
        emitter.discard(1)
        XCTAssert(emitter.values == [0])

        emitter.discard(0)
        XCTAssert(emitter.values == [])
    }

    func testDiscardAll() {
        let emitter = newIntEmitter()

        emitter.emit(0)
        emitter.emit(1)
        emitter.discard()
        XCTAssert(emitter.values == [])
    }

    func testValueStackLimiting() {
        let emitter = newIntEmitter()
        emitter.valueStackDepth = 1

        emitter.emit(0)
        XCTAssert(emitter.values == [0])

        emitter.emit(1)
        XCTAssert(emitter.values == [1])
    }

    func testEmitterDelegateSubscribe() {
        let delegate = DummyDelegate()

        let emitter = newIntEmitter()
        emitter.delegate = delegate

        XCTAssert(delegate.registerCallParameters == nil)
        XCTAssert(delegate.unregisterCallParameters == nil)

        let subscriber = Subscriber<Int>(AnyMatcher<Int>(), handler: { _ in })
        emitter.subscribe(subscriber)

        XCTAssert(delegate.registerCallParameters?.sender === emitter)
        XCTAssert(delegate.registerCallParameters?.subscriber === subscriber)
        XCTAssert(delegate.unregisterCallParameters == nil)

        emitter.unsubscribe(subscriber)
        XCTAssert(delegate.unregisterCallParameters?.sender === emitter)
        XCTAssert(delegate.unregisterCallParameters?.subscriber === subscriber)
    }

    func testEmitterDelegateEmit() {
        let delegate = DummyDelegate()

        let emitter = newIntEmitter()
        emitter.delegate = delegate

        XCTAssert(delegate.emitCallParameters == nil)

        let emitValue: Int = 1
        emitter.emit(emitValue)

        XCTAssert(delegate.emitCallParameters?.sender === emitter)
        XCTAssert((delegate.emitCallParameters?.value as? Int) == emitValue)
    }

    func testEmitterDelegateReplace() {
        let delegate = DummyDelegate()

        let emitter = newIntEmitter()
        emitter.delegate = delegate

        XCTAssert(delegate.replaceCallParameters == nil)

        let replaceValue: Int = 1
        emitter.replace(replaceValue)

        XCTAssert(delegate.replaceCallParameters?.sender === emitter)
        XCTAssert((delegate.replaceCallParameters?.value as? Int) == replaceValue)
    }

    func testEmitterDelegatePropagate() {
        let delegate = DummyDelegate()

        let emitter = newIntEmitter()
        emitter.delegate = delegate

        XCTAssert(delegate.propagateCallParameters == nil)

        let replaceValue: Int = 1
        emitter.replace(replaceValue)

        XCTAssert(delegate.propagateCallParameters == nil)

        let subscriber = Subscriber<Int>(AnyMatcher<Int>(), handler: { _ in })
        emitter.subscribe(subscriber)

        XCTAssert(delegate.propagateCallParameters?.sender === emitter)
        XCTAssert(delegate.propagateCallParameters?.subscriber === subscriber)
        XCTAssert((delegate.propagateCallParameters?.value as? Int) == replaceValue)
    }

    func testEmitterDelegateDiscard() {
        let delegate = DummyDelegate()

        let emitter = newIntEmitter()
        emitter.delegate = delegate

        XCTAssert(delegate.discardCallParameters == nil)

        let value: Int = 1
        emitter.discard(value)

        XCTAssert(delegate.discardCallParameters == nil)

        emitter.replace(value)
        emitter.discard(value)

        XCTAssert(delegate.discardCallParameters?.sender === emitter)
        XCTAssert((delegate.discardCallParameters?.value as? Int) == value)
    }
}
