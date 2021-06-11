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
  
  func testWriteTextFile() throws {
//    let data = Data([240, 159, 152, 184, 240, 159, 152, 185, 0b1111_0000, 0b1001_1111, 0b1001_1000, 186, 0xF0, 0x9F, 0x98, 187])
    
    AtomicFileHandler.writeFile(filePath: "Cats.txt", contents: "😸😹😺😻", characterSet: .utf8) { (retVal, error) in
      XCTAssertEqual("😸😹😺😻", retVal)
    }
  }
  
//  func testWriteJSON() throws {
//    let jsonData = Data([{"key";: "value"}]);
//
//  }
//
//  func testOverwriteJSON() throws {
//
//  }
//
//  func testBadCharacterSet() throws {
//
//  }
//
//  func testBadFilePath() throws {
//
  }
  
//  func testGetNameForCodeCoverage() throws {
//
//  }

