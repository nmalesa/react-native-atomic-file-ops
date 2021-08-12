import Foundation

class AtomicFileHandler {
  enum AtomicFileHandlerError : Error, Equatable {
    case badEncoding, badFilePath
    
    var definition: String {
      switch self {
      case .badEncoding:
        return "ERROR Bad Encoding:  Please enter valid character set."
      case .badFilePath:
        return "ERROR Bad File Path:  Please enter valid file path."
      }
    }
  }
  
  public static func multiplyAsync(a: Float, b: Float, completionHandler:(Float) -> Void) -> Void {
      completionHandler(a * b)
  }
  
  public static func writeFile(fileName: String, contents: String, characterSet: String, directory: String? = nil, completionHandler: (String?, Error?) -> Void) -> Void {
    let directoryPath = (directory != nil) ? URL(fileURLWithPath: directory!) : FileManager.documentDirectoryURL
    let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryPath)
    
    let caseNeutralCharacterSet = characterSet.lowercased()
    
    var encoded: Data?
    
    switch caseNeutralCharacterSet {
      case "utf8":
        encoded = contents.data(using: .utf8)
      case "ascii":
        encoded = contents.data(using: .ascii)
      case "base64":
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
