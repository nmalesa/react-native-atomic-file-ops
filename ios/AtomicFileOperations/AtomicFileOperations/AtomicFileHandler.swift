//
//  AtomicFileHandler.swift
//  AtomicFileOperations
//
//  Created by Carl Brown on 11/9/20.
//

import Foundation

class AtomicFileHandler {
    
    // VERSION FROM ATOMICFILEOPS
    public static func saveData(fileURL: URL, data: Data, completionHandler:@escaping (String?, Error?) -> Void) -> Void {
        do {
            try data.write(to: fileURL)
            
            let savedData = try Data(contentsOf: fileURL)
            
            let output = String(data: savedData, encoding: .utf8)
            
            try output?.write(to: fileURL, atomically: true, encoding: .utf8)
            
            let atomicOutput = try String(contentsOf: fileURL)
            
            completionHandler(atomicOutput, nil)
        } catch {
            completionHandler(nil, error)
        }
    }
    
    
    
    
    
    
    
    
    
//// REFACTOR SAVEDATA AND WRITEATOMICFILE TO A) USE UINT8 DATA INSTEAD OF JSON; AND B) USE WRITEATOMICFILE INSIDE OF SAVEDATA (TEST #4)
//    public static func writeAtomicFile(filePath: String, data: Data) -> String {
//        let url = URL(fileURLWithPath: filePath, relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("txt")
//
//        do {
//            try data.write(to: url)
//
//            let savedData = try Data(contentsOf: url)
//
//            let output = String(data: savedData, encoding: .utf8)
//
//            try output?.write(to: url, atomically: true, encoding: .utf8)
//
//            let testOutput = try String(contentsOf: url)
//
//            return testOutput
//        } catch {
//            let errorMessage = "Error: \(Error.self)"
//
//            return errorMessage
//        }
//    }
//
//
////    AtomicFileHandler.saveData(fileURL: url, data: data) { (retVal) in
////        resolve(retVal)
//
//    public static func saveData(api: String, filePath: String, completionHandler:@escaping (String?, Error?) -> Void) -> Void {
//        let session: URLSession = URLSession(configuration: .default)
//
//        guard let url = URL(string: api) else {
//            completionHandler(nil, URLError(.badURL))
//            return
//        }
//
//        session.dataTask(with: url) {data, response, error in
//                if error != nil {
//                    completionHandler(nil, error)
//                    return
//                }
//
//                guard let data = data else {
//                    completionHandler(nil, URLError(.badServerResponse))
//                    return
//                }
//
//                let output = writeAtomicFile(filePath: filePath, data: data)
//
//                completionHandler(output, nil)
//        }
//    }
    
    public static func multiplyAsync(a: Float, b: Float, completionHandler:(Float) -> Void) -> Void {
        completionHandler(a * b)
    }
}
