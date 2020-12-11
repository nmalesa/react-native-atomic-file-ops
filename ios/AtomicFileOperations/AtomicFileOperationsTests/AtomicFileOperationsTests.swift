//
//  AtomicFileOperationsTests.swift
//  AtomicFileOperationsTests
//
//  Created by Carl Brown on 11/9/20.
//

import XCTest
@testable import AtomicFileOperations

class AtomicFileOperationsTests: XCTestCase {

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        AtomicFileHandler.multiplyAsync(a: 5.0, b: 11.0) { (retVal) in
            XCTAssertEqual(55.0, retVal)
        }
    }
    
    let fileURL = URL(fileURLWithPath: "Cats.txt", relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])

    let data = Data([240, 159, 152, 184, 240, 159, 152, 185, 0b1111_0000, 0b1001_1111, 0b1001_1000, 186, 0xF0, 0x9F, 0x98, 187])
    
    func testSaveData() throws {
        AtomicFileHandler.saveData(fileURL: fileURL, data: data) { (retVal, error) in
            XCTAssertEqual("😸😹😺😻", retVal)
        }
    }
//    func testFetchTodos() throws {
//        let exp = expectation(description: "fetching todos from server")
//
//        let session: URLSession = URLSession(configuration: .default)
//
//        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")
//
//        session.dataTask(with: url!) {data, response, error in
//            XCTAssertNil(error)
//            exp.fulfill()
//        }.resume()
//
//        waitForExpectations(timeout: 10.0) { (error) in
//            print(error?.localizedDescription ?? "Error")
//        }
//    }
    
// WORKING TEST 4 - REMODEL AFTER TESTFETCHTODOS
//    func testSaveData() throws {
//        let exp = expectation(description: "Fetches data from server")
//
//        AtomicFileHandler.saveData(api: "https://raw.githubusercontent.com/nmalesa/cat-emojis/gh-pages/index.md", filePath: "Cats") { (retVal, error) in
//            XCTAssertEqual("😸😹😺😻", retVal)
//            exp.fulfill()
//        }
//
//        waitForExpectations(timeout: 10.0) { (error) in
//            XCTFail("timeout")
//        }
//    }

    
    
//    func testRetrieveJSONTodos() throws {
//        struct Response: Codable {
//            let title: String
//        }
//
//        let session: URLSession = URLSession(configuration: .default)
//
//        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")
//
//        session.dataTask(with: url!) {data, response, error in
//            do {
//                let res = try JSONDecoder().decode([Response].self, from: data!)
//                XCTAssertEqual("delectus aut autem", res[0].title)
//                // exp.fulfill()
//            } catch let error {
//                print(error)
//            }
//        }.resume()
//    }
    

}
