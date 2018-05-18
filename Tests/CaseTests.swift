//
//  CaseTests.swift
//  Ion
//
//  Created by Anton K on 2/21/18.
//

import XCTest
@testable import Ion

class CaseTests: XCTestCase {

    func testCase() {
        let intCase00 = Case<Int, Int>(key: 0, content: 0)
        let intCase10 = Case<Int, Int>(key: 1, content: 0)
        let intCase01 = Case<Int, Int>(key: 0, content: 1)

        XCTAssert(intCase00 != intCase10)
        XCTAssert(intCase00 == intCase01)
    }

    func testSome() {
        let intSome0 = Some<Int>(0)
        let intSome1 = Some<Int>(1)
        XCTAssert(intSome0.content != intSome1.content)
    }
}
