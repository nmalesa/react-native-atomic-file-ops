//
//  AtomicFileHandler.swift
//  AtomicFileOperations
//
//  Created by Carl Brown on 11/9/20.
//

import Foundation

class AtomicFileHandler {
    public static func saveData(fileURL: URL, data: Data, completionHandler:(Float) -> Void) -> Void {
        completionHandler(a * b)
        // Revise closure
        
        do{
            try data.write(to: fileURL, atomically: true)
            let input = try String(contentsOf: fileURL)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }
}
