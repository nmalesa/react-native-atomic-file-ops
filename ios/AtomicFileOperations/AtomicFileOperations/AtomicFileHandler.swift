//
//  AtomicFileHandler.swift
//  AtomicFileOperations
//
//  Created by Carl Brown on 11/9/20.
//

import Foundation

class AtomicFileHandler {
    
    
//    func add(num1:Int, num2:Int) -> Int {
//        return num1 + num2
//    }
//
//    func addTwoNumbers(num1: Int, num2: Int) -> Int {
//        add(num1: num1, num2: num2)
//    }
//
//    print(addTwoNumbers(num1: 4, num2: 6))
    
//    struct Response: Codable {
//        let title: String
//    }
    
    
    // try inputtedData.write(to: url.appendingPathExtension("txt"))
    //
    //            let savedData = try Data(contentsOf: url)
    //
    //            let output = String(data: savedData, encoding: .utf8)!
    //
    //            try output.write(to: url, atomically: true, encoding: .utf8)
    //
    //            let testOutput = try String(contentsOf: url)

    
    public static func writeAtomicFile(filePath: String, data: [UInt8]) -> String {
        let url = URL(fileURLWithPath: filePath, relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("txt")

        let inputtedData = Data(data)
    
        do {
            try inputtedData.write(to: url)
          
            let savedData = try Data(contentsOf: url)
            
            let output = String(data: savedData, encoding: .utf8)
            
            try output?.write(to: url, atomically: true, encoding: .utf8)
            
            let testOutput = try String(contentsOf: url)
            
            return testOutput
        } catch {
            let errorMessage = "Error: \(Error.self)"
            
            return errorMessage
        }
    }
    
    public static func saveData(api: String, filePath: String, completionHandler:@escaping (String?, Error?) -> Void) -> Void {
        let session: URLSession = URLSession(configuration: .default)

        guard let url = URL(string: api) else {
            completionHandler(nil, URLError(.badURL))
            return
        }

        session.dataTask(with: url) {data, response, error in
            do {
                if error != nil {
                    completionHandler(nil, error)
                    return
                }

                guard case let data = [UInt8](data!) else {
                    completionHandler(nil, URLError(.badServerResponse))
                    return
                }
                
                let output = writeAtomicFile(filePath: filePath, data: data)

                completionHandler(output, nil)
            } catch let error {
                completionHandler(nil, error)
            }
        }
    }
    
    
    
    
    
    
    
    
    // WORKING WRITE FUNCTION WITH HARDCODED ARRAY OF STRINGS (WORKING TEST 2)
    //    public static func writeAtomicFile(filePath: String, data: [String], completionHandler:(String?, Error?) -> Void) -> Void {
    //        let fileURL = URL(fileURLWithPath: filePath, relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("txt")
    //
    //        let firstItem = data.first ?? "Error: No items listed."
    //
    //        do {
    //          try firstItem.write(to: fileURL, atomically: true, encoding: .utf8)
    //          let testOutput = try String(contentsOf: fileURL)
    //          completionHandler(testOutput, nil)
    //        } catch let error {
    //          completionHandler(nil, error)
    //        }
    //    }
    
    
//   WORKING SAVEDATA FUNCTION WITH FETCH AND WRITE FUNCTIONALITY (TEST 3)
//    public static func saveData(api: String, filePath: String, completionHandler:@escaping (String?, Error?) -> Void) -> Void {
//
//        // Dependent on whether or not data is in JSON format.  "title" specifically for testing todos dataset.
//        struct Response: Codable {
//            let title: String
//        }
//
//        let session: URLSession = URLSession(configuration: .default)
//
//        guard let url = URL(string: api) else {
//            completionHandler(nil, URLError(.badURL))
//            return
//        }
//
//        session.dataTask(with: url) {data, response, error in
//            do {
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
//                let res = try JSONDecoder().decode([Response].self, from: data)
//
//                let fileURL = URL(fileURLWithPath: filePath, relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("txt")
//
//                // Specifically for testing todos dataset.  Need to revise for universal use.
//                if let todoData = res.first?.title {
//                    try todoData.write(to: fileURL, atomically: true, encoding: .utf8)
//
//                    let testOutput = try String(contentsOf: fileURL)
//
//                    completionHandler(testOutput, nil)
//                } else {
//                    completionHandler(nil, URLError(.badServerResponse))
//                }
//            } catch let error {
//                completionHandler(nil, error)
//            }
//        }
//    }
    
    
    
    public static func multiplyAsync(a: Float, b: Float, completionHandler:(Float) -> Void) -> Void {
            completionHandler(a * b)
        }
}





//  WORKING SAVEDATA FUNCTION WITH FETCH FUNCTIONALITY
//    public static func saveData(api: String, completionHandler:@escaping (String) -> Void) -> Void {
//        struct Response: Codable {
//            let title: String
//        }
//
//        let session: URLSession = URLSession(configuration: .default)
//
//        let url = URL(string: api)
//
//        session.dataTask(with: url!) {data, response, error in
//            do {
//                let res = try JSONDecoder().decode([Response].self, from: data!)
//                completionHandler(res[0].title)
//            } catch let error {
//                print(error)
//                return
//            }
//        }.resume()
//    }

//  WORKING SAVEDATA FUNCTION WITH WRITE FUNCTIONALITY
//    public static func saveData(data: [UInt8], filePath: String, completionHandler:(String) -> Void) -> Void {
//        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//        let inputtedData = Data(data)
//
//        let url = URL(fileURLWithPath: filePath, relativeTo: documentDirectoryURL)
//
//        do {
//            try inputtedData.write(to: url.appendingPathExtension("txt"))
//
//            let savedData = try Data(contentsOf: url)
//
//            let output = String(data: savedData, encoding: .utf8)!
//
//            try output.write(to: url, atomically: true, encoding: .utf8)
//
//            let testOutput = try String(contentsOf: url)
//
//            completionHandler(testOutput)
//        } catch let error {
//            print(error)
//            return
//        }
//     }
