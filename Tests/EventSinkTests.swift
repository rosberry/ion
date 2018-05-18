//
//  EventSinkTests.swift
//  Ion
//
//  Created by Anton K on 2/22/18.
//

import XCTest
@testable import Ion

class EventSinkTests: XCTestCase {
    
    class MockEventSink<T: Equatable>: EventSink {

        var emitValue: T?
        func emit(_ value: T) {
            emitValue = value
        }

        var replaceValue: T?
        func replace(_ value: T) {
            replaceValue = value
        }

        var discardValue: T?
        func discard(_ value: T) {
            discardValue = value
        }

        var didCallDiscardAll = false
        func discard() {
            didCallDiscardAll = true
        }
    }

    func testTypeEraser() {
        let mock = MockEventSink<Int>()
        let sink = AnyEventSink(mock)

        sink.emit(1)
        XCTAssert(mock.emitValue == 1)

        sink.replace(2)
        XCTAssert(mock.replaceValue == 2)

        sink.discard(3)
        XCTAssert(mock.discardValue == 3)

        sink.discard()
        XCTAssert(mock.didCallDiscardAll)
    }
}
