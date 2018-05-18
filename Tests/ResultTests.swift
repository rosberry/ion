//
//  ResultTests.swift
//  Ion
//
//  Created by Anton K on 3/29/18.
//

import XCTest
@testable import Ion

class ResultTests: XCTestCase {

    enum AnyError: Error {
        case any
    }

    enum EquatableError: Error, Equatable {
        case one
        case two
    }

    func testAnyResult() {
        let result1: Result<Any> = .success(0)
        let result2: Result<Any> = .success(1)
        let result3: Result<Any> = .failure(AnyError.any)

        XCTAssert(result1.type == .success)
        //XCTAssert(result1.content == 0)
        XCTAssert(result1.error == nil)

        XCTAssert(result3.type == .failure)
        XCTAssert(result3.content == nil)
        XCTAssert(result3.error is AnyError)

        XCTAssert(result1 == result2)
        XCTAssert(result1 != result3)
        XCTAssert(result3 == result3)
    }

    func testEquatableResult() {
        let result1: Result<Int> = .success(0)
        let result2: Result<Int> = .success(1)
        let result3: Result<Int> = .success(0)
        let result4: Result<Int> = .failure(AnyError.any)

        XCTAssert(result1.type == .success)
        XCTAssert(result1.content == 0)
        XCTAssert(result1.error == nil)

        XCTAssert(result4.type == .failure)
        XCTAssert(result4.content == nil)
        XCTAssert(result4.error is AnyError)

        XCTAssert(result1 != result2)
        XCTAssert(result1 == result3)
        XCTAssert(result1 != result4)
        XCTAssert(result4 == result4)
    }
}

