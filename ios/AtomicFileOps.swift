import Foundation

@objc(AtomicFileOps)
class AtomicFileOps: NSObject {

    // VERSION 1:  Writing atomic file functionality ONLY 
//    @objc(multiply:withB:withResolver:withRejecter:)
//    func createURLs(fileName: String, fileContent: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
//
//    let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
    // Get rid of appendingPathExtension
//    let fileURL = URL(fileURLWithPath: fileName, relativeTo: documentDirectoryURL).appendingPathExtension("txt")
//
//
//   // Pass .utf8 in as parameter
// guard let data = fileContent.data(using: .utf8) else {
//            reject(nil, error)
//            return
//        }
//
//        AtomicFileHandler.saveData(fileURL: fileURL, data: data) { (retVal) in
//            resolve(retVal)
//        }
//    }
    
    // VERSION 2:  Fetch and write functionality
    @objc(multiply:withB:withResolver:withRejecter:)
    func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        AtomicFileHandler.multiplyAsync(a: a, b: b) { (retVal) in
            resolve(retVal)
        }
    }

    @objc(writeFile:withData:withOptions:withResolver:withRejecter:)
  // options = The string "UTF8"
    func writeFile(filePath: String, data: String, options: String, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
      var stringEncoding: String.Encoding = .ascii
      if options = "UTF8" {
        stringEncoding = .utf8
        //TODO: Check for other values
      }
        AtomicFileHandler.writeFile(fileName: filePath, contents: data, characterSet: stringEncoding, pathExtension: <#T##String#>) { (returnString, error) in
            guard error == nil else {
                reject("Error", error?.localizedDescription, error)
                return
            }
            resolve(returnString);
        }
    }
    
    @objc public static func requiresMainQueueSetup() -> Bool {
        return false
    }
}
