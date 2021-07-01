import Foundation

class AtomicFileHandler {
  
  public static func multiplyAsync(a: Float, b: Float, completionHandler:(Float) -> Void) -> Void {
      completionHandler(a * b)
  }
  
  public static func writeFile(fileName: String, contents: String, characterSet: String, directory: String? = nil, completionHandler: (String?, Error?) -> Void) -> Void {
    let directoryPath = (directory != nil) ? URL(fileURLWithPath: directory!) : FileManager.documentDirectoryURL
    let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryPath)
    
    // JavaScript doesn't have a CharacterSet type.  Need to convert String passed in from JavaScript to typesafe parameter.
    var stringEncoding: String.Encoding = .ascii
    
    switch characterSet {
      case "UTF8":
        stringEncoding = .utf8
      case "ASCII":
        stringEncoding = .ascii
      case "BASE64":
        stringEncoding = .base64
      default:
        print("Error: Invalid character set.")
    }
    
    do {
      try contents.write(to: fileURL, atomically: true, encoding: stringEncoding)
      
      let atomicOutput = try String(contentsOf: fileURL)
      
      completionHandler(atomicOutput, nil)
    } catch {
      completionHandler(nil, error)
    }
  }
}
