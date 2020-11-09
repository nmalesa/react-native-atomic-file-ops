//
//  AtomicFileOperationsTests.swift
//  AtomicFileOperationsTests
//
//  Created by Carl Brown on 11/9/20.
//

import XCTest
@testable import AtomicFileOperations

class AtomicFileOperationsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        AtomicFileHandler.multiplyAsync(a: 5.0, b: 11.0) { (retVal) in
            XCTAssertEqual(55.0, retVal)
        }
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
