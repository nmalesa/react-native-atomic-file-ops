import Foundation

@objc(AtomicFileOps)
class AtomicFileOps: NSObject {
    @objc(writeFile:withData:withOptions:withResolver:withRejecter:)
    func writeFile(fileName: String, contents: String, encoding: String, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
      AtomicFileHandler.writeFile(fileName: fileName, contents: contents, encoding: encoding) { (returnString, error) in
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
