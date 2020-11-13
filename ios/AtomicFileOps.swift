import Foundation

@objc(AtomicFileOps)
class AtomicFileOps: NSObject {

    @objc(multiply:withB:withResolver:withRejecter:)
    func createURLs(fileName: String, fileContent: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("txt")
        
        let content = fileContent
        
        let data = content.data(using: .utf8)
        
        AtomicFileHandler.saveData(fileURL: fileURL, data: data) { (retVal) in
            resolve(retVal)
        }
    }
}
