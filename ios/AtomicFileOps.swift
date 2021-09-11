import Foundation

@objc(AtomicFileOps)
class AtomicFileOps: NSObject {
    @objc(writeFile:withData:withOptions:withResolver:withRejecter:)
    func writeFile(filePath: String, data: String, options: String, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
      AtomicFileHandler.writeFile(fileName: filePath, contents: data, characterSet: options) { (returnString, error) in
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
