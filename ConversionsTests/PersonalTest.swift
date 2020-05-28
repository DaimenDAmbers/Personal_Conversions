//
//  PersonalTest.swift
//  ConversionsTests
//
//  Created by Daimen Ambers on 5/26/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import XCTest
@testable import Conversions

class PersonalTest: XCTestCase {
    var sut: Personal!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = Personal()
        sut.create(Conversion(title: "New Conversion", fromValue: "Inch", toValue: "Feet", operation: .multiply, factor: 10))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNewConversion() {
        // 1. Given: Give any values needed
        
        // 2. When: Execute the code to be tested
        
        // 3. Then: Assert the results that you expect
    }

}
