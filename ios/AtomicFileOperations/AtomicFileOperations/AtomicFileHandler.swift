import Foundation

class AtomicFileHandler {
  enum AtomicFileHandlerError : Error {
    case badEncoding
  }
  
  public static func multiplyAsync(a: Float, b: Float, completionHandler:(Float) -> Void) -> Void {
      completionHandler(a * b)
  }
  
  public static func writeFile(fileName: String, contents: String, characterSet: String, directory: String? = nil, completionHandler: (String?, Error?) -> Void) -> Void {
    let directoryPath = (directory != nil) ? URL(fileURLWithPath: directory!) : FileManager.documentDirectoryURL
    let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryPath)
    
    // JavaScript doesn't have a CharacterSet type.  Need to convert String passed in from JavaScript to typesafe parameter.
    
    var encoded: Data?
    
    switch characterSet {
      case "UTF8":
        encoded = contents.data(using: .utf8)
      case "ASCII":
        encoded = contents.data(using: .ascii)
      case "BASE64":
        encoded = contents.data(using: .utf8)?.base64EncodedData()
      default:
        completionHandler(nil, AtomicFileHandlerError.badEncoding)
        return
    }
    
    guard let encoded = encoded else {
      completionHandler(nil, AtomicFileHandlerError.badEncoding)
      return
    }
    
    do {
      try encoded.write(to: fileURL, options: .atomic)
      
      let atomicOutput = try String(contentsOf: fileURL)
      
      completionHandler(atomicOutput, nil)
    } catch {
      completionHandler(nil, error)
    }
  }
}
