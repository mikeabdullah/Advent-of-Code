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
    let mostCommon = (0..<12).map { input.lines[column: $0].mostCommon()! }
    let leastCommon = (0..<12).map { input.lines[column: $0].leastCommon()! }
    
    let gammaRate = try XCTUnwrap(Int(String(mostCommon), radix: 2))
    let epsilonRate = try XCTUnwrap(Int(String(leastCommon), radix: 2))
    
    XCTAssertEqual(gammaRate * epsilonRate, 3309596)
  }

}

extension Sequence where Element : Hashable {
  
  /// Iterates the sequence, totalling the occurrences of each element.
  func mostCommon() -> Element? {
    elementCounts.max { lhs, rhs in
      lhs.value < rhs.value
    }?.key
  }
  
  func leastCommon() -> Element? {
    elementCounts.max { lhs, rhs in
      lhs.value > rhs.value
    }?.key
  }
  
  /// Counts the number of occurrences of each element in the sequence.
  var elementCounts: [Element: Int] {
    self.reduce(into: [:]) { result, element in
      result[element] = (result[element] ?? 0) + 1
    }
  }
}
