//
//  EventSourceTests.swift
//  Ion
//
//  Created by Anton K on 2/22/18.
//

import XCTest
@testable import Ion

class EventSourceTests: XCTestCase {
    
    class MockEventSource<T: Equatable>: EventSource {

        var subscriber: Subscriber<T>?
        var matcher: Any?
        var handler: ((T) -> Void)?

        func subscribe<M: Matcher>(_ matcher: M, handler: @escaping (T) -> Void) -> Subscriber<T> where T == M.T {
            self.matcher = matcher
            self.handler = handler

            let subscriber = Subscriber(matcher, handler: handler)
            self.subscriber = subscriber

            return subscriber
        }

        func subscribe(_ subscriber: Subscriber<T>) -> Subscriber<T> {
            self.subscriber = subscriber
            return subscriber
        }

        func resubscribe(_ subscriber: Subscriber<T>) {
            self.subscriber = subscriber
        }

        func unsubscribe(_ subscriber: Subscriber<T>) {
            self.subscriber = nil
        }
    }

    func testTypeEraser() {
        let mock = MockEventSource<Int>()
        let source = AnyEventSource(mock)

        var didCallHandler = false
        let matcher = AnyMatcher<Int>()
        let handler = { (element: Int) in
            didCallHandler = true
        }

        let subscriber = source.subscribe(matcher, handler: handler)
        mock.handler?(0)
        XCTAssert(mock.matcher is AnyMatcher<Int>)
        XCTAssert(didCallHandler)

        source.subscribe(subscriber)
        XCTAssert(mock.subscriber == subscriber)

        source.unsubscribe(subscriber)
        XCTAssert(mock.subscriber == nil)

        source.resubscribe(subscriber)
        XCTAssert(mock.subscriber == subscriber)
    }
}
