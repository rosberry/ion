//
//  SubscriberTests.swift
//  Ion
//
//  Created by Anton K on 2/22/18.
//

import XCTest
@testable import Ion

class SubscriberTests: XCTestCase {

    func newIntEmitter() -> Emitter<Int> {
        return Emitter<Int>()
    }

    func newIntMatcher() -> AnyMatcher<Int> {
        return AnyMatcher<Int>()
    }

    func testSubscribe() {
        let emitter = newIntEmitter()
        let sourceValue: Int = 1
        var didCatchValue = false

        let matcher = newIntMatcher()
        _ = emitter.subscribe(matcher, handler: { (value: Int) in
            XCTAssert(sourceValue == value)
            didCatchValue = true
        })

        emitter.emit(sourceValue)
        XCTAssert(didCatchValue == true)
    }

    func testReplay() {
        let emitter = newIntEmitter()
        let sourceValue: Int = 1
        var didCatchValue = false

        let matcher = newIntMatcher()
        let subscriber = Subscriber<Int>(matcher) { (value: Int) in
            XCTAssert(sourceValue == value)
            didCatchValue = true
        }

        emitter.emit(sourceValue)
        emitter.subscribe(subscriber)
        XCTAssert(didCatchValue == true)
    }

    func testResubscribe() {
        let emitter = newIntEmitter()
        let sourceValue: Int = 1
        var valueCount: Int = 0

        let matcher = newIntMatcher()
        let subscriber = emitter.subscribe(matcher, handler: { (value: Int) in
            XCTAssert(sourceValue == value)
            valueCount += 1
        })

        emitter.emit(sourceValue)
        emitter.resubscribe(subscriber)

        XCTAssert(valueCount == 2)
    }

    func testUnsubscribe() {
        let emitter = newIntEmitter()
        let sourceValue: Int = 1
        var valueCount: Int = 0

        let matcher = newIntMatcher()
        let subscriber = emitter.subscribe(matcher, handler: { (value: Int) in
            XCTAssert(sourceValue == value)
            valueCount += 1
        })

        emitter.emit(sourceValue)
        emitter.unsubscribe(subscriber)
        emitter.emit(sourceValue)

        XCTAssert(valueCount == 1)
    }
}
