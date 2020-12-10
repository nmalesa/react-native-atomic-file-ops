import Foundation

@objc(AtomicFileOps)
class AtomicFileOps: NSObject {

    // VERSION 1:  Writing atomic file functionality ONLY 
//    @objc(multiply:withB:withResolver:withRejecter:)
//    func createURLs(fileName: String, fileContent: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
//
//    let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//    let fileURL = URL(fileURLWithPath: fileName, relativeTo: documentDirectoryURL).appendingPathExtension("txt")
//
//        guard let data = fileContent.data(using: .utf8) else {
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
    func handleData(api: String, fileName: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: documentDirectoryURL).appendingPathExtension("txt")
        
        let session: URLSession = URLSession(configuration: .default)
        
        guard let url = URL(string: api) else {
            reject(nil, URLError(.badURL))
            return
        }
        
        session.dataTask(with: url) {data, response, error in
            if error != nil {
                reject(nil, error)
                return
            }
            
            guard let data = data else {
                reject(nil, URLError(.badServerResponse))
                return
            }
            
            AtomicFileHandler.saveData(fileURL: fileURL, data: data) { (retVal) in
                resolve(retVal)
            }
        }
    }
}
