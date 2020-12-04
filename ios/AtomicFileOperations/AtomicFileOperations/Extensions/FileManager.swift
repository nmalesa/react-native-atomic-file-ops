//
//  FileManager.swift
//  AtomicFileOperations
//
//  Created by Natalia Malesa on 12/3/20.
//

import Foundation

public extension FileManager {
    static var documentDirectoryURL: URL {
        `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
