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
    func writeFile(filePath: String, data: String, options: String, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
        //FIXME: Fix the forced unwrap on data here
        //FIXME: Pass Options through and make use of them
        AtomicFileHandler.saveData(fileURL: URL(fileURLWithPath: filePath), data: data.data(using: .utf8)!) { (returnString, error) in
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

    
    func handleData(api: String, fileName: String, resolve:@escaping RCTPromiseResolveBlock, reject:@escaping RCTPromiseRejectBlock) -> Void {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let fileURL = URL(fileURLWithPath: fileName, relativeTo: documentDirectoryURL).appendingPathExtension("txt")

        let session: URLSession = URLSession(configuration: .default)

        guard let url = URL(string: api) else {
            reject("Bad URL", "Bad URL", URLError(.badURL))
            return "Error"
        }

        session.dataTask(with: url) {data, response, error in
            if error != nil {
                reject("Error", "Error", error)
                return
            }

            guard let data = data else {
                reject("Bad server", "Bad server", URLError(.badServerResponse))
                return
            }

            AtomicFileHandler.saveData(fileURL: fileURL, data: data) { (retVal, error) in
                if error != nil {
                    reject("Error", "Error", error)
                    return
                }

                guard let retVal = retVal else {
                    reject("Bad URL", "Bad URL", URLError(.badServerResponse))
                    return
                }
                resolve(retVal)
            }
        }
        
        return "This is a test"
    }
}
