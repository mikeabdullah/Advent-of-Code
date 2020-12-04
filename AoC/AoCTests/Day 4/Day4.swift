//
//  Day4.swift
//  AoCTests
//
//  Created by Mike on 04/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day4: XCTestCase {
    
    var batches: [Substring]!

    override func setUpWithError() throws {
        let location = Bundle(for: Day2.self).url(forResource: "input-4", withExtension: "txt")!
        var input = try String(contentsOf: location)
        input = input.replacingOccurrences(of: "\n\n", with: "§")
        input = input.replacingOccurrences(of: "\n", with: " ")
        batches = input.split(separator: "§")
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

}
