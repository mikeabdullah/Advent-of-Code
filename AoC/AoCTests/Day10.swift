//
//  Day10.swift
//  AoCTests
//
//  Created by Mike on 10/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day10: XCTestCase {

    var input: [Int]!
    
    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-10", withExtension: "txt")!
        let input = try String(contentsOf: location)
        self.input = input.lines.map { Int($0)! }
    }
    
    func testSample1() throws {
        
        let location = Bundle(for: Self.self).url(forResource: "sample-input-10", withExtension: "txt")!
        let input = try String(contentsOf: location)
        let jolts = input.lines.map { Int($0)! }
        
        var sorted = jolts.sorted()
        sorted.insert(0, at: 0) // the charging port
        
        let (stepsOf1, stepsOf3) = sorted.stepsOf1And3()
        
        XCTAssertEqual(stepsOf1, 22)
        XCTAssertEqual(stepsOf3 + 1, 10)    // extra one for device
    }
}


extension Array where Element == Int {
    
    func stepsOf1And3() -> (Int, Int) {
        
        let pairs = zip(self, self.dropFirst())
        let steps = pairs.map { pair in
            return pair.1 - pair.0
        }
        
        let stepsOf1 = steps.count(of: 1)
        let stepsOf3 = steps.count(of: 3)
        return (stepsOf1, stepsOf3)
    }
}
