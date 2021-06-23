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
    AtomicFileHandler.writeFile(filePath: filePath, contents: jsonString, characterSet: .utf8, pathExtension: ".json") { (retVal, error) in
      XCTAssertEqual("[{\"key\": \"value\"}]", retVal)
    }

    // Clean up
    if fileExists {
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
    AtomicFileHandler.writeFile(filePath: filePath, contents: jsonString, characterSet: .utf8, pathExtension: ".json") { (retVal, error) in
      XCTAssertEqual("[{\"key\": \"value\"}]", retVal)
    }
      
    // Overwrite the file with a shorter string, and read the file back in.
    AtomicFileHandler.writeFile(filePath: filePath, contents: "[]", characterSet: .utf8, pathExtension: ".json") { (retVal, error) in
      XCTAssertEqual("[]", retVal)
    }
  
    // Clean up
    if fileExists {
      try FileManager.default.removeItem(atPath: filePath)
    }
  }
  
  // FINISH THIS TEST AFTER WRITING THE PUBLIC / PRIVATE CHARACTER SET WRITEFILE FUNCTIONS (TO HANDLE STRING FOR JAVASCRIPT)
//  func testBadCharacterSet() throws {
//    let jsonString: String = "[{\"key\": \"value\"}]"
//    let time = Date().timeIntervalSince1970
//    let timeString = String(time).replacingOccurrences(of: ".", with: "_")
//    let filePath: String = "AtomicFileOpsModuleTest.test." + timeString
  
  // let fileExists: Bool = FileManager.default.fileExists(atPath: filePath)
//
//    // Add code to make sure the file doesn't already exist
//
//    AtomicFileHandler.writeFile(filePath: filePath, contents: jsonString, characterSet: "No Such Character Set", pathExtension: ".json") { (retVal, error) in
//      XCTAssertEqual("[{\"key\": \"value\"}]", retVal)
//    }
//

//  }
  
  func testBadFilePath() throws {
    let jsonString: String = "[{\"key\": \"value\"}]"
    let filePath: String = "../../../No Such File/AtomicFileOpsModuleTest.test";
    
    let fileExists: Bool = FileManager.default.fileExists(atPath: filePath)
    
    AtomicFileHandler.writeFile(filePath: filePath, contents: jsonString, characterSet: .utf8, pathExtension: ".json") { (retVal, error) in
      XCTAssertEqual(false, fileExists)  // DON'T KNOW THAT THIS IS HANDLED CORRECTLY
    }
  }
}
