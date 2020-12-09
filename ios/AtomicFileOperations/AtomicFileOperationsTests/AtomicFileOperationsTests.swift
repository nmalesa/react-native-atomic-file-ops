//
//  AtomicFileOperationsTests.swift
//  AtomicFileOperationsTests
//
//  Created by Carl Brown on 11/9/20.
//

import XCTest
@testable import AtomicFileOperations

class AtomicFileOperationsTests: XCTestCase {

//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        AtomicFileHandler.multiplyAsync(a: 5.0, b: 11.0) { (retVal) in
//            XCTAssertEqual(55.0, retVal)
//        }
//    }
    
//        func testSaveData() throws {
//            AtomicFileHandler.saveData(data: [240, 159, 152, 184, 240, 159, 152, 185, 0b1111_0000, 0b1001_1111, 0b1001_1000, 186, 0xF0, 0x9F, 0x98, 187], filePath: "Cats") { (retVal)  in
//                XCTAssertEqual("😸😹😺😻", retVal)
//            }
//
//    let cats: [UInt8] = [240, 159, 152, 184, 240, 159, 152, 185, 0b1111_0000, 0b1001_1111, 0b1001_1000, 186, 0xF0, 0x9F, 0x98, 187]
//
//    func testWriteFile() throws {
//        AtomicFileHandler.writeAtomicFile(filePath: "Favorite Animals", data: cats) { (retVal, error) in
//            XCTAssertEqual("😸😹😺😻", retVal)
//        }
//    }
    

    

// WORKING TEST 2
//        func testWriteFile() throws {
//            AtomicFileHandler.writeAtomicFile(filePath: "Favorite Animals", data: ["Cats", "Dogs", "Fish", "Lizards"]) { (retVal, error) in
//                XCTAssertEqual("Cats", retVal)
//            }
//        }
//

//  WORKING TEST 3
//    func testSaveData() throws {
//        AtomicFileHandler.saveData(api: "https://jsonplaceholder.typicode.com/todos", filePath: "Todos") { (retVal, error) in
//            XCTAssertEqual("delectus aut autem", retVal)
//        }
//    }
    
// WORKING TEST 4
    func testSaveData() throws {
        AtomicFileHandler.saveData(api: "https://raw.githubusercontent.com/nmalesa/cat-emojis/gh-pages/index.md", filePath: "Cats") { (retVal, error) in
            XCTAssertEqual("😸😹😺😻", retVal)
        }
    

    
    
//    func testWriteFile() throws {
//        AtomicFileHandler.writeAtomicFile((filePath: "Todos", animals: ["Cats", "Dogs", "Fish", "Lizards"]), { (retVal, error) in
//            XCTAssertEqual("Cats", retVal)
//        }
//    }
   
   
    
    func testWriteCatsFile() throws {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let cats: [UInt8] = [240, 159, 152, 184, 240, 159, 152, 185, 0b1111_0000, 0b1001_1111, 0b1001_1000, 186, 0xF0, 0x9F, 0x98, 187]

        let catsData = Data(cats)

        let catsURL = URL(fileURLWithPath: "Cats", relativeTo: documentDirectoryURL)

        try? catsData.write(to: catsURL.appendingPathExtension("txt"))

        guard let savedCatsData = try? Data(contentsOf: catsURL) else
        {
            XCTFail("Bad cats data")
            return
        }
        
        let emojis = "😸😹😺😻"
        
        let catString = String(data: savedCatsData, encoding: .utf8)
        
        try? catString?.write(to: catsURL, atomically: true, encoding: .utf8)
        
        let catTestString = try? String(contentsOf: catsURL)
        
        XCTAssertEqual(emojis, catTestString)
    }
    
    func testFetchTodos() throws {
        let exp = expectation(description: "fetching todos from server")
        
        let session: URLSession = URLSession(configuration: .default)
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")
        
        session.dataTask(with: url!) {data, response, error in
            XCTAssertNil(error)
            exp.fulfill()
        }.resume()
        
        waitForExpectations(timeout: 10.0) { (error) in
            print(error?.localizedDescription ?? "Error")
        }
    }
    
    func testRetrieveJSONTodos() throws {
        struct Response: Codable {
            let title: String
        }
        
        let session: URLSession = URLSession(configuration: .default)
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")
        
        session.dataTask(with: url!) {data, response, error in
            do {
                let res = try JSONDecoder().decode([Response].self, from: data!)
                XCTAssertEqual("delectus aut autem", res[0].title)
                // exp.fulfill()
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func testWriteTodosFile() throws {
        struct Response: Codable {
            let title: String
        }
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let session: URLSession = URLSession(configuration: .default)
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")
        
        session.dataTask(with: url!) {data, response, error in
            do {
                let res = try JSONDecoder().decode([Response].self, from: data!)
                
                let todosURL = URL(fileURLWithPath: "Todos", relativeTo: documentDirectoryURL).appendingPathExtension("txt")
                
                let todo = res[0].title
                
                let testTodo = "delectus aut autem"
                
                try todo.write(to: todosURL, atomically: true, encoding: .utf8)
                
                let todoTestString = try String(contentsOf: todosURL)
                
                XCTAssertEqual(testTodo, todoTestString)
            } catch let error {
                print(error)
            }
        }.resume()
    }
}

}
