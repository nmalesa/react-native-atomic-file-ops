import XCTest
@testable import AtomicFileOperations

class AtomicFileOperationsTests: XCTestCase {
  let jsonData = "[{\"key\": \"value\"}]"
  let fileName = "AtomicFileOpsModuleTest.test"
  let directory = FileManager.documentDirectoryURL
  lazy var filePath = directory.appendingPathComponent(fileName).path
  
  override func setUp() {
    super.setUp()

    // Make sure file does not already exist
    do {
      if FileManager.default.fileExists(atPath: filePath) {
        try FileManager.default.removeItem(atPath: filePath)
      }
    } catch {
      print(error)
    }
    
    XCTAssertFalse(FileManager.default.fileExists(atPath: filePath))
  }
  
  func testWriteJSON() throws {
    let expectation = self.expectation(description: "File written.")
        
    // Write out the full file, and read the file back in 
    AtomicFileHandler.writeFile(fileName: fileName, contents: jsonData, characterSet: "UTF8", directory: directory.path) { (retVal, error) in
      XCTAssertEqual("[{\"key\": \"value\"}]", retVal)
    
      if let existingError = error {
        XCTFail(existingError.localizedDescription)
      }
      
      XCTAssertTrue(FileManager.default.fileExists(atPath: filePath))
      expectation.fulfill()
    }

    waitForExpectations(timeout: 10) { error in
      if let existingError = error {
        XCTFail(existingError.localizedDescription)
      }
    }
  }
    
  func testOverwriteJSON() throws {
    let expectation = self.expectation(description: "File written.")
      
    AtomicFileHandler.writeFile(fileName: fileName, contents: jsonData, characterSet: "UTF8", directory: directory.path) { (retVal, error) in
      XCTAssertEqual("[{\"key\": \"value\"}]", retVal)
      
      if let existingError = error {
        XCTFail(existingError.localizedDescription)
      }
      
      XCTAssertTrue(FileManager.default.fileExists(atPath: filePath))
      expectation.fulfill()
    }
    
    let overwriteExpectation = self.expectation(description: "File overwritten.")

    // Overwrite the file with a shorter string, and read the file back in.
    AtomicFileHandler.writeFile(fileName: fileName, contents: "[]", characterSet: "UTF8", directory: directory.path) { (retVal, error) in
      XCTAssertEqual("[]", retVal)
      
      if let existingError = error {
        XCTFail(existingError.localizedDescription)
      }
      
      XCTAssertTrue(FileManager.default.fileExists(atPath: filePath))
      overwriteExpectation.fulfill()
    }
    
    waitForExpectations(timeout: 10) { error in
      if let existingError = error {
        XCTFail(existingError.localizedDescription)
      }
    }
  }
  
  func testBadCharacterSet() throws {
    let expectation = self.expectation(description: "File written.")
    AtomicFileHandler.writeFile(fileName: fileName, contents: jsonData, characterSet: "No Such Character Set", directory: directory.path) { (retVal, error) in
      XCTAssertEqual(nil, retVal)
      XCTAssertTrue(error is AtomicFileHandler.AtomicFileHandlerError)
      XCTAssertFalse(FileManager.default.fileExists(atPath: filePath))
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 10) { error in
      if let existingError = error {
        XCTFail(existingError.localizedDescription)
      }
    }
  }
  
  func testBadFileName() throws {
    let expectation = self.expectation(description: "File written.")

    AtomicFileHandler.writeFile(fileName: "No/Such/File", contents: jsonData, characterSet: "UTF8", directory: directory.path) { (retVal, error) in
      XCTAssertEqual(nil, retVal)
      XCTAssertTrue(error is AtomicFileHandler.AtomicFileHandlerError)
      XCTAssertFalse(FileManager.default.fileExists(atPath: filePath))
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 10) { error in
      if let existingError = error {
        XCTFail(existingError.localizedDescription)
      }
    }
  }
}
