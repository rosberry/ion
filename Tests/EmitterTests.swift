//
//  Ion_iOSTests.swift
//  Ion iOSTests
//
//  Created by Anton K on 2/21/18.
//

import XCTest
@testable import Ion

class EmitterTests: XCTestCase {

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
}
