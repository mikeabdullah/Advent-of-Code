//
//  Day9.swift
//  AoCTests
//
//  Created by Mike on 09/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day9: XCTestCase {

    var input: [Int]!
    
    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-9", withExtension: "txt")!
        let input = try String(contentsOf: location)
        self.input = input.lines.map { Int($0)! }
    }

    func testPart1() throws {
        
        let (_, firstInvalid) = input.enumerated().dropFirst(25).first(where: { i, value in
            let preceding = input[i-25 ..< i]
            return preceding.firstCombination(summingTo: value) == nil
        })!
        
        XCTAssertEqual(firstInvalid, 27911108)
    }

}
