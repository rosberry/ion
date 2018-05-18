//
//  MatcherTests.swift
//  Ion
//
//  Created by Anton K on 2/21/18.
//

import XCTest
@testable import Ion

class MatcherTests: XCTestCase {

    func testAnyMatcher() {
        let matcher = AnyMatcher<Int>()
        XCTAssert(matcher.match(1))
        XCTAssert(matcher.transform(1) == 1)
    }

    func testObjectMatcher() {
        let matcher = ObjectMatcher<Int>(object: 1)
        XCTAssert(matcher.match(1))
        XCTAssert(matcher.match(0) == false)
        XCTAssert(matcher.transform(1) == 1)
    }

    func testPropertyMatcher() {
        let matcher = PropertyMatcher<String, Int>(keyPath: \String.count, value: 5)
        XCTAssert(matcher.match("match"))
        XCTAssert(matcher.match("mismatch") == false)
        XCTAssert(matcher.transform("transform") == "transform")
    }

    func testClosureMatcher() {
        let matcher = ClosureMatcher<Int>(closure: { (value: Int) -> (Bool) in
            return value == 1
        })
        XCTAssert(matcher.match(1))
        XCTAssert(matcher.match(0) == false)
        XCTAssert(matcher.transform(1) == 1)
    }

    func testTrainMatcher() {
        let elementMatcher = ObjectMatcher<Int>(object: 1)
        let matcher = TrainMatcher<[Int]>(elementMatcher: elementMatcher)

        let train: [Int] = [1, 2, 3]
        XCTAssert(matcher.match(train))
        XCTAssert(matcher.transform(train) == [1])
    }

    func testResultMatcher() {
        typealias IntResult = Result<Int>
        enum IntError: Error {
            case some
        }

        let successMatcher = ResultMatcher<IntResult>.success
        let failureMatcher = ResultMatcher<IntResult>.failure

        XCTAssert(successMatcher.match(IntResult.success(1)))
        XCTAssert(successMatcher.match(IntResult.failure(IntError.some)) == false)

        XCTAssert(failureMatcher.match(IntResult.failure(IntError.some)))
        XCTAssert(failureMatcher.match(IntResult.success(1)) == false)
    }
}
