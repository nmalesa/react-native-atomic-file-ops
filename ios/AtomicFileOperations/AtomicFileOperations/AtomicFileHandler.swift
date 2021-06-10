import Foundation

class AtomicFileHandler {
  
  public static func multiplyAsync(a: Float, b: Float, completionHandler:(Float) -> Void) -> Void {
      completionHandler(a * b)
  }
  
  public static func writeFile(filePath: String, contents: Data, characterSet: String.Encoding, completionHandler: (String?, Error?) -> Void) -> Void {
    let fileURL = URL(fileURLWithPath: filePath, relativeTo: FileManager.documentDirectoryURL)
    
    do {
      try contents.write(to: fileURL)
      
      let savedData = try Data(contentsOf: fileURL)
      
      let output = String(data: savedData, encoding: characterSet)
      
      try output?.write(to: fileURL, atomically: true, encoding: characterSet)
      
      let atomicOutput = try String(contentsOf: fileURL)
      
      completionHandler(atomicOutput, nil)
    } catch {
      completionHandler(nil, error)
    }
  }
}
