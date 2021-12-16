import Foundation

class AtomicFileHandler {
  enum AtomicFileHandlerError : Error, Equatable {
    case badEncoding, badFileName
  }
  
  public static func writeFile(fileName: String, contents: String, encoding: String, directory: String? = nil, completionHandler: (String?, Error?) -> Void) -> Void {
    let directoryPath = (directory != nil) ? URL(fileURLWithPath: directory!) : FileManager.documentDirectoryURL
    
    guard !fileName.contains("/") else {
      completionHandler(nil, AtomicFileHandlerError.badFileName)
      return
    }
    
    let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryPath)
    
    var encoded: Data?
    
    switch encoding.lowercased() {
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
