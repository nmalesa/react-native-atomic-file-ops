@objc(AtomicFileOps)
class AtomicFileOps: NSObject {

    @objc(multiply:withB:withResolver:withRejecter:)
    func (a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileURL = URL(fileURLWithPath: "Test Message", relativeTo: directoryURL).appendingPathExtension("txt")
        
        let myContent = "This is a test."
        
        let data = myContent.data(using: .utf8)
        
        AtomicFileHandler.multiplyAsync(a: a, b: b) { (retVal) in
            resolve(retVal)
        }
    }
}
