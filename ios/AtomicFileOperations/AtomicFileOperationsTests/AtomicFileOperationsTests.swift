import XCTest
@testable import AtomicFileOperations

class AtomicFileOperationsTests: XCTestCase {
  func testWriteJSON() throws {
    let jsonString: String = "[{\"key\": \"value\"}]"
    let time = Date().timeIntervalSince1970
    let timeString = String(time).replacingOccurrences(of: ".", with: "_")
    let fileName: String = "AtomicFileOpsModuleTest.test." + timeString + ".json"
    let directory = FileManager.documentDirectoryURL
    let filePath = directory.appendingPathComponent(fileName).path

    // Make sure file does not already exist
    if FileManager.default.fileExists(atPath: filePath) {
      try FileManager.default.removeItem(atPath: filePath)
    }
    XCTAssertFalse(FileManager.default.fileExists(atPath: filePath))
    
    // Set expectation to verify asynchronous writing behaves as expected
    let expectation = self.expectation(description: "File written.")
        
    // Write out the full file, and read the file back in 
    AtomicFileHandler.writeFile(fileName: fileName, contents: jsonString, characterSet: "UTF8", directory: directory.path) { (retVal, error) in
      XCTAssertEqual("[{\"key\": \"value\"}]", retVal)
      if let existingError = error { // Could be guard statement alternatively (idiomatic Swift)
        XCTFail(existingError.localizedDescription)
      }
      XCTAssertTrue(FileManager.default.fileExists(atPath: filePath))
      expectation.fulfill()
    }

    waitForExpectations(timeout: 10) { error in
      if let existingError = error { // Could be guard statement alternatively (idiomatic Swift)
        XCTFail(existingError.localizedDescription)
      }
    }
    
    // Clean up
    if FileManager.default.fileExists(atPath: filePath) {
      try FileManager.default.removeItem(atPath: filePath)
    }
  }
    
  func testOverwriteJSON() throws {
    let jsonString: String = "[{\"key\": \"value\"}]"
    let time = Date().timeIntervalSince1970
    let timeString = String(time).replacingOccurrences(of: ".", with: "_")
    let fileName: String = "AtomicFileOpsModuleTest.test." + timeString + ".json"
    let directory = FileManager.documentDirectoryURL
    let filePath = directory.appendingPathComponent(fileName).path
      
    // Make sure file does not already exist
    if FileManager.default.fileExists(atPath: filePath) {
      try FileManager.default.removeItem(atPath: filePath)
    }
    XCTAssertFalse(FileManager.default.fileExists(atPath: filePath))
    
    // Set expectation to verify asynchronous writing behaves as expected
    let expectation = self.expectation(description: "File written.")
      
    // Write out the full file, and read the file back in
    AtomicFileHandler.writeFile(fileName: fileName, contents: jsonString, characterSet: "UTF8", directory: directory.path) { (retVal, error) in
      XCTAssertEqual("[{\"key\": \"value\"}]", retVal)
      if let existingError = error { // Could be guard statement alternatively (idiomatic Swift)
        XCTFail(existingError.localizedDescription)
      }
      XCTAssertTrue(FileManager.default.fileExists(atPath: filePath))
      expectation.fulfill()
    }
    
    let overwriteExpectation = self.expectation(description: "File overwritten.")

    // Overwrite the file with a shorter string, and read the file back in.
    AtomicFileHandler.writeFile(fileName: fileName, contents: "[]", characterSet: "UTF8", directory: directory.path) { (retVal, error) in
      XCTAssertEqual("[]", retVal)
      if let existingError = error { // Could be guard statement alternatively (idiomatic Swift)
        XCTFail(existingError.localizedDescription)
      }
      XCTAssertTrue(FileManager.default.fileExists(atPath: filePath))
      overwriteExpectation.fulfill()
    }
    
    waitForExpectations(timeout: 10) { error in
      if let existingError = error { // Could be guard statement alternatively (idiomatic Swift)
        XCTFail(existingError.localizedDescription)
      }
    }
  
    // Clean up
    if FileManager.default.fileExists(atPath: filePath) {
      try FileManager.default.removeItem(atPath: filePath)
    }
  }
  
  func testBadCharacterSet() throws {
    let jsonString: String = "[{\"key\": \"value\"}]"
    let time = Date().timeIntervalSince1970
    let timeString = String(time).replacingOccurrences(of: ".", with: "_")
    let fileName: String = "AtomicFileOpsModuleTest.test." + timeString + ".json"
    let directory = FileManager.documentDirectoryURL
    let filePath = directory.appendingPathComponent(fileName).path

    // Make sure file does not already exist
    if FileManager.default.fileExists(atPath: filePath) {
      try FileManager.default.removeItem(atPath: filePath)
    }
    XCTAssertFalse(FileManager.default.fileExists(atPath: filePath))
    
    // Set expectation to verify asynchronous writing behaves as expected
    let expectation = self.expectation(description: "File written.")
        
    // Write out the full file, and read the file back in
    AtomicFileHandler.writeFile(fileName: fileName, contents: jsonString, characterSet: "No Such Character Set", directory: directory.path) { (retVal, error) in
      XCTAssertEqual(nil, retVal)
      XCTAssertTrue(error is AtomicFileHandler.AtomicFileHandlerError)
      XCTAssertFalse(FileManager.default.fileExists(atPath: filePath))
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 10) { error in
      if let existingError = error { // Could be guard statement alternatively (idiomatic Swift)
        XCTFail(existingError.localizedDescription)
      }
    }
    
    // Clean up
    if FileManager.default.fileExists(atPath: filePath) {
      try FileManager.default.removeItem(atPath: filePath)
    }
  }
  
  func testBadFilePath() throws {
    let jsonString: String = "[{\"key\": \"value\"}]"
    let fileName: String = "No/Such/File"
    let directory = FileManager.documentDirectoryURL
    let filePath = directory.appendingPathComponent(fileName).path

    
    // Make sure file does not already exist
    if FileManager.default.fileExists(atPath: filePath) {
      try FileManager.default.removeItem(atPath: filePath)
    }
    XCTAssertFalse(FileManager.default.fileExists(atPath: filePath))
    
    // Set expectation to verify asynchronous writing behaves as expected
    let expectation = self.expectation(description: "File written.")

    AtomicFileHandler.writeFile(fileName: fileName, contents: jsonString, characterSet: "UTF8", directory: directory.path) { (retVal, error) in
      XCTAssertEqual(nil, retVal)
      XCTAssertTrue(error is AtomicFileHandler.AtomicFileHandlerError)
      XCTAssertFalse(FileManager.default.fileExists(atPath: filePath))
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 10) { error in
      if let existingError = error { // Could be guard statement alternatively (idiomatic Swift)
        XCTFail(existingError.localizedDescription)
      }
    }
    
    // Clean up
    if FileManager.default.fileExists(atPath: filePath) {
      try FileManager.default.removeItem(atPath: filePath)
    }
  }
}
