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
    AtomicFileHandler.writeFile(fileName: "Cats", contents: "😸😹😺😻", characterSet: .utf8, pathExtension: ".txt") { (retVal, error) in
      XCTAssertEqual("😸😹😺😻", retVal)
    }
  }
  
  func testWriteJSON() throws {
    let jsonString: String = "[{\"key\": \"value\"}]"
    let time = Date().timeIntervalSince1970
    let timeString = String(time).replacingOccurrences(of: ".", with: "_")
    let fileName: String = "AtomicFileOpsModuleTest.test." + timeString
    let directory = FileManager.documentDirectoryURL
    let filePath = directory.appendingPathComponent(fileName).appendingPathExtension(".json").path

    // Make sure file does not already exist
    if FileManager.default.fileExists(atPath: filePath) {
      try FileManager.default.removeItem(atPath: filePath)
    }
  
    XCTAssertFalse(FileManager.default.fileExists(atPath: filePath))
    
    let expectation = self.expectation(description: "File written.")
        
    // Write out the full file, and read the file back in 
    AtomicFileHandler.writeFile(fileName: fileName, contents: jsonString, characterSet: .utf8, pathExtension: ".json", directory: directory.path) { (retVal, error) in
      XCTAssertEqual("[{\"key\": \"value\"}]", retVal)
      if let existingError = error { // Could be guard statement alternatively (idiomatic Swift)
        XCTFail(existingError.localizedDescription)
      }
      let fileExists: Bool = FileManager.default.fileExists(atPath: filePath)
      XCTAssertTrue(fileExists)
      expectation.fulfill()
    }

    // Clean up   // RUNNING TOO EARLY - THINK ASYNC
    waitForExpectations(timeout: 10) { error in
      if let existingError = error { // Could be guard statement alternatively (idiomatic Swift)
        XCTFail(existingError.localizedDescription)
      }
    }
    
    if FileManager.default.fileExists(atPath: filePath) {
      try FileManager.default.removeItem(atPath: filePath)
    }
  }
    
  func testOverwriteJSON() throws {
    let jsonString: String = "[{\"key\": \"value\"}]"
    let time = Date().timeIntervalSince1970
    let timeString = String(time).replacingOccurrences(of: ".", with: "_")
    let filePath: String = "AtomicFileOpsModuleTest.test." + timeString
      
    // Make sure file does not already exist
    let fileExists: Bool = FileManager.default.fileExists(atPath: filePath) // Need absolute path?
    
    if fileExists {
      try FileManager.default.removeItem(atPath: filePath)
      XCTAssertEqual(false, fileExists)
    }
      
    // Write out the full file, and read the file back in
    AtomicFileHandler.writeFile(fileName: filePath, contents: jsonString, characterSet: .utf8, pathExtension: ".json") { (retVal, error) in
      XCTAssertEqual("[{\"key\": \"value\"}]", retVal)
    }
      
    // Overwrite the file with a shorter string, and read the file back in.
    AtomicFileHandler.writeFile(fileName: filePath, contents: "[]", characterSet: .utf8, pathExtension: ".json") { (retVal, error) in
      XCTAssertEqual("[]", retVal)
    }
  
    // Clean up
    if fileExists {
      try FileManager.default.removeItem(atPath: filePath)
    }
  }
  
  // FINISH THIS TEST AFTER HANDLING CHARACTER SET STRING CONVERSION
//  func testBadCharacterSet() throws {
//    let jsonString: String = "[{\"key\": \"value\"}]"
//    let time = Date().timeIntervalSince1970
//    let timeString = String(time).replacingOccurrences(of: ".", with: "_")
//    let filePath: String = "AtomicFileOpsModuleTest.test." + timeString
  
  // Make sure file does not already exist
//  let fileExists: Bool = FileManager.default.fileExists(atPath: filePath) // Need absolute path?
//
//  if fileExists {
//    try FileManager.default.removeItem(atPath: filePath)
//    XCTAssertEqual(false, fileExists)
//  }
//
//    AtomicFileHandler.writeFile(filePath: filePath, contents: jsonString, characterSet: "No Such Character Set", pathExtension: ".json") { (retVal, error) in
//      XCTAssertEqual(false, fileExists) // DON'T KNOW THAT THIS IS HANDLED CORRECTLY
//    }
//  }
  
  func testBadFilePath() throws {
    let jsonString: String = "[{\"key\": \"value\"}]"
    let filePath: String = "../../../No Such File/AtomicFileOpsModuleTest.test";
    
    let fileExists: Bool = FileManager.default.fileExists(atPath: filePath)
    
    AtomicFileHandler.writeFile(fileName: filePath, contents: jsonString, characterSet: .utf8, pathExtension: ".json") { (retVal, error) in
      XCTAssertEqual(false, fileExists)  // DON'T KNOW THAT THIS IS HANDLED CORRECTLY
    }
  }
}
