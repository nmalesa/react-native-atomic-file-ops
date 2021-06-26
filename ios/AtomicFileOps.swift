import Foundation

@objc(AtomicFileOps)
class AtomicFileOps: NSObject {
    @objc(multiply:withB:withResolver:withRejecter:)
    func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        AtomicFileHandler.multiplyAsync(a: a, b: b) { (retVal) in
            resolve(retVal)
        }
    }

    @objc(writeFile:withData:withOptions:withResolver:withRejecter:)
    func writeFile(filePath: String, data: String, options: String, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
      var stringEncoding: String.Encoding = .ascii
      if options = "UTF8" {
        stringEncoding = .utf8
        //TODO: Check for other values
      }
        AtomicFileHandler.writeFile(fileName: filePath, contents: data, characterSet: stringEncoding) { (returnString, error) in
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
