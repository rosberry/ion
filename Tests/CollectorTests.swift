//
//  CollectorTests.swift
//  Ion
//
//  Created by Anton K on 2/22/18.
//

import XCTest
@testable import Ion

class CollectorTests: XCTestCase {

    func testDirectSource() {
        let emitter = Emitter<Int>()
        let collector = Collector(source: emitter)
        var eventCount: Int = 0

        let matcher = AnyMatcher<Int>()
        collector.subscribe(matcher) { (i: Int) in
            eventCount += 1
        }
        emitter.emit(1)
        XCTAssert(eventCount == 1)

        collector.resubscribe()
        XCTAssert(eventCount == 2)
    }

    func testTypeErasedSource() {
        let emitter = Emitter<Int>()
        let collector = Collector(source: AnyEventSource(emitter))
        var value: Int = 0

        let matcher = AnyMatcher<Int>()
        collector.subscribe(matcher) { (i: Int) in
            value = i
        }
        emitter.emit(1)
        XCTAssert(value == 1)
    }

    func testUnsubscribe() {
        let emitter = Emitter<Int>()
        let collector = Collector(source: AnyEventSource(emitter))
        var value: Int = 0

        let subscriber = collector.subscribe { (i: Int) in
            value = i
        }
        emitter.emit(1)
        XCTAssert(value == 1)

        collector.unsubscribe(subscriber)
        emitter.emit(2)
        XCTAssert(value == 1)
    }

    func testGeneralConvenienceFunctions() {
        let emitter = Emitter<Int>()
        let collector = Collector(source: emitter)
        var value = -1

        collector.subscribe { (i: Int) in
            value = i
        }
        emitter.emit(1)
        collector.unsubscribe()
        XCTAssert(value == 1)

        collector.subscribe(0, handler: { (i: Int) in
            value = i
        })
        emitter.emit(0)
        collector.unsubscribe()
        XCTAssert(value == 0)

        collector.subscribe(\Int.hashValue, value: 1.hashValue, handler: { (i: Int) in
            value = i
        })
        emitter.emit(1)
        collector.unsubscribe()
        XCTAssert(value == 1)

        collector.subscribe({ (_) in return true}, handler: { (i: Int) in
            value = i
        })
        emitter.emit(2)
        collector.unsubscribe()
        XCTAssert(value == 2)
    }

    func testResultConvenienceFunctions() {
        typealias IntResult = Result<Int>
        enum IntError: Error {
            case some
        }

        let emitter = Emitter<IntResult>()
        let collector = Collector(source: emitter)

        var value = -1
        collector.subscribeSuccess { (content: Int) in
            value = content
        }

        emitter.emit(IntResult.success(1))
        XCTAssert(value == 1)

        var didCatchFailure = false
        collector.subscribeFailure { (error: Error) in
            didCatchFailure = true
        }

        emitter.emit(IntResult.failure(IntError.some))
        XCTAssert(didCatchFailure)
    }
}
