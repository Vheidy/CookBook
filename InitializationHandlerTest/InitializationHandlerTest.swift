//
//  InitializationHandlerTest.swift
//  InitializationHandlerTest
//
//  Created by OUT-Salyukova-PA on 28.04.2021.
//

import XCTest
@testable import CookBook
import CoreData

@objc class MockSaveObject: NSObject, SaveObjectProtocol {
    var initialNumber = 0
    
    func save(objectName: String, params: [String: Any]) throws {
        initialNumber += 1
    }
    
    func fetchObjectsCount(request: NSFetchRequest<NSManagedObject>) -> Int {
        initialNumber
    }
}

class InitializationHandlerTest: XCTestCase {
    
    var testingHandler: InitializationHandler!

    override func setUp() {
        let mock = MockSaveObject()
        self.testingHandler = InitializationHandler(service: mock)
    }
    
    override  func tearDown() {
        self.testingHandler = nil
    }
    
    func testFirstInitialization() {
        // Given
        testingHandler.saveInitialization()
        
        // When
        let result = testingHandler.fetchNumberOfInitialization()
        
        // Then
        XCTAssertEqual(result, 1, "First initialization is not 1, result value: \(result)")
    }
    
    func testWithoutSave() {
        let result = testingHandler.fetchNumberOfInitialization()
        XCTAssertEqual(result, 0, "Initialization without first save isn't 0, result value: \(result)")
    }

    func testRunTenTimes() throws {
        measure {
            testingHandler.saveInitialization()
        }
        let result = testingHandler.fetchNumberOfInitialization()
        XCTAssertEqual(result, 10, "Count initialization is not the same value that the fetch return, result value: \(result)")
    }
    
    func testRunTenTimesWithoutSave() throws {
        measure {
            let result = testingHandler.fetchNumberOfInitialization()
            XCTAssertEqual(result, 0, "Count initialization is not the same value that the fetch return, result value: \(result)")
        }
    }
    
    func testRunTenTimesWithOneSave() throws {
        testingHandler.saveInitialization()
        measure {
            let result = testingHandler.fetchNumberOfInitialization()
            XCTAssertEqual(result, 1, "Count initialization is not the same value that the fetch return, result value: \(result)")
        }
    }

}
