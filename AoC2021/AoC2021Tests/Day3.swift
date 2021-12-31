//
//  Day3.swift
//  AoC2021Tests
//
//  Created by Mike on 31/12/2021.
//

import XCTest

class Day3: XCTestCase {

  func testPart1() throws {
    let input = try PuzzleInput(named: "input-3")
    
    /// the number of ones in each column
    var oneCounts = Array(repeating: 0, count: 12)
    for row in input.lines {
      for (n, character) in row.enumerated() {
        switch character {
        case "1": oneCounts[n] += 1
        case "0": break
        default: throw CocoaError(.fileReadCorruptFile)
        }
      }
    }
    
    let gammaBits = oneCounts.map { count in
      count > input.lines.count / 2 ? "1" : "0"
    }
    let gammaRate = try XCTUnwrap(Int(gammaBits.joined(), radix: 2))
    
    let epsilonBits = oneCounts.map { count in
      count < input.lines.count / 2 ? "1" : "0"
    }
    let epsilonRate = try XCTUnwrap(Int(epsilonBits.joined(), radix: 2))
    
    XCTAssertEqual(gammaRate * epsilonRate, 3309596)
  }

}
