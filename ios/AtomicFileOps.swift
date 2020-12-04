import Foundation

@objc(AtomicFileOps)
class AtomicFileOps: NSObject {

    @objc(multiply:withB:withResolver:withRejecter:)
    func createURLs(fileName: String, fileContent: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        
//        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("txt")
//
//        let content = fileContent
//
//        let data = content.data(using: .utf8) // Should this be a guard statement?
        // Make sure tests past, THEN:
        // HERE:
        // If error is not nil, reject with error
        // If string is not nil, success with string
        
        AtomicFileHandler.saveData(fileURL: fileURL, data: data) { (retVal) in
            resolve(retVal)
        }
    }
}
