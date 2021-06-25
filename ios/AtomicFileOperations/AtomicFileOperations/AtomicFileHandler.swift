import Foundation

class AtomicFileHandler {
  
  public static func multiplyAsync(a: Float, b: Float, completionHandler:(Float) -> Void) -> Void {
      completionHandler(a * b)
  }
  
  //TODO: REMOVE PATHEXTENSION
  // GO UP TO EXAMPLE APP IN JAVASCRIPT AND GET CAVY TEST RUNNING ALL THE WAY THROUGH 
  public static func writeFile(fileName: String, contents: String, characterSet: String.Encoding, pathExtension: String, directory: String? = nil,
                  completionHandler: (String?, Error?) -> Void) -> Void {
    let directoryPath = (directory != nil) ? URL(fileURLWithPath: directory!) : FileManager.documentDirectoryURL
    let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryPath).appendingPathExtension(pathExtension)
    
    // Need to convert characterSetName string into String.Encoding (for JavaScript)
    // let charSet = characterSetName.cString(using: String.Encoding)
    
    do {
      try contents.write(to: fileURL, atomically: true, encoding: characterSet)
      
      // Reading the file back in.  Should this be included here in writeFile or used in testing only?
      let atomicOutput = try String(contentsOf: fileURL)
      
      completionHandler(atomicOutput, nil)
    } catch {
      completionHandler(nil, error)
    }
  }
}
