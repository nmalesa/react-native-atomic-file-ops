//
//  AtomicFileHandler.swift
//  AtomicFileOperations
//
//  Created by Carl Brown on 11/9/20.
//

import Foundation

class AtomicFileHandler {
    public static func multiplyAsync(a: Float, b: Float, completionHandler:(Float) -> Void) -> Void {
        completionHandler(a * b)
    }
}
