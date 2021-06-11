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
    AtomicFileHandler.writeFile(filePath: "Cats", contents: "😸😹😺😻", characterSet: .utf8, pathExtension: ".txt") { (retVal, error) in
      XCTAssertEqual("😸😹😺😻", retVal)
    }
  }
  
  func testWriteJSON() throws {
    let jsonData: String = "[{\"key\": \"value\"}]"
    let time = Date().timeIntervalSince1970
    let timeString = String(time).replacingOccurrences(of: ".", with: "_")
    let filePath: String = "AtomicFileOpsModuleTest.test." + timeString
    
    AtomicFileHandler.writeFile(filePath: filePath, contents: jsonData, characterSet: .utf8, pathExtension: ".json") { (retVal, error) in
      XCTAssertEqual("[{\"key\": \"value\"}]", retVal)
    }

  }
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

