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
      
      // JavaScript doesn't have a CharacterSet type.  Need to convert String passed in from JavaScript to typesafe parameter.
      var stringEncoding: String.Encoding = .ascii
      
      switch options {
      case "UTF8":
        stringEncoding = .utf8
      case "UTF16":
        stringEncoding = .utf16
      case "UTF32":
        stringEncoding = .utf32
      default:
        print("Error: Character encoding must be Unicode.  UTF-8 is preferred.")
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
