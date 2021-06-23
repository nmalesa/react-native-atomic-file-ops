import Foundation

class AtomicFileHandler {
  
  public static func multiplyAsync(a: Float, b: Float, completionHandler:(Float) -> Void) -> Void {
      completionHandler(a * b)
  }
  
  public static func writeFile(filePath: String, contents: String, characterSet: String.Encoding, pathExtension: String, completionHandler: (String?, Error?) -> Void) -> Void {
    let fileURL = URL(fileURLWithPath: filePath, relativeTo: FileManager.documentDirectoryURL).appendingPathExtension(pathExtension)
    
    do {
      try contents.write(to: fileURL, atomically: true, encoding: characterSet)
      
      // Reading the file back in.  Should this be included here in writeFile or extracted and used in testing only?
      let atomicOutput = try String(contentsOf: fileURL)
      
      completionHandler(atomicOutput, nil)
    } catch {
      completionHandler(nil, error)
    }
  }
}
