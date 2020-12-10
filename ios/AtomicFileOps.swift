import Foundation

@objc(AtomicFileOps)
class AtomicFileOps: NSObject {

    // VERSION 1:  Writing atomic file functionality ONLY 
    @objc(multiply:withB:withResolver:withRejecter:)
    func createURLs(fileName: String, fileContent: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        
        let url = URL(fileURLWithPath: fileName, relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("txt")

        guard let data = fileContent.data(using: .utf8) else {
            reject(nil, error)
            return
        }
        
        AtomicFileHandler.saveData(fileURL: url, data: data) { (retVal) in
            resolve(retVal)
        }
    }
}



//public static func saveData(api: String, filePath: String, completionHandler:@escaping (String?, Error?) -> Void) -> Void {
//    let session: URLSession = URLSession(configuration: .default)
//
//    guard let url = URL(string: api) else {
//        completionHandler(nil, URLError(.badURL))
//        return
//    }
//
//    session.dataTask(with: url) {data, response, error in
//            if error != nil {
//                completionHandler(nil, error)
//                return
//            }
//
//            guard let data = data else {
//                completionHandler(nil, URLError(.badServerResponse))
//                return
//            }
//
//            let output = writeAtomicFile(filePath: filePath, data: data)
//
//            completionHandler(output, nil)
//    }
//}
