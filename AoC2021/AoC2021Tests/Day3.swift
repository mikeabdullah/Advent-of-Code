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
    
    let mostCommon = (0..<12).map { input.lines[column: $0].mostCommon()! }
    let leastCommon = (0..<12).map { input.lines[column: $0].leastCommon()! }
    
    let gammaRate = try XCTUnwrap(Int(String(mostCommon), radix: 2))
    let epsilonRate = try XCTUnwrap(Int(String(leastCommon), radix: 2))
    
    XCTAssertEqual(gammaRate * epsilonRate, 3309596)
  }

  func testPart2() throws {
    let input = try PuzzleInput(named: "input-3")
    
    var oxygenNumbers = input.lines
    for index in 0..<12 {
      let counts = oxygenNumbers[column: index].elementCounts
      let count1 = counts["1"] ?? 0
      let count0 = counts["0"] ?? 0
      let mostCommon: Character = count1 >= count0 ? "1" : "0"
      oxygenNumbers = oxygenNumbers.filter { $0[offset: index] == mostCommon }
    }
    
    var co2Numbers = input.lines
    for index in 0..<12 {
      let counts = co2Numbers[column: index].elementCounts
      let count1 = counts["1"] ?? 0
      let count0 = counts["0"] ?? 0
      let leastCommon: Character = count0 <= count1 ? "0" : "1"
      co2Numbers = co2Numbers.filter { $0[offset: index] == leastCommon }
      if co2Numbers.count == 1 { break }
    }
    
    let oxygen = try XCTUnwrap(Int(String(oxygenNumbers[0]), radix: 2))
    let co2 = try XCTUnwrap(Int(String(co2Numbers[0]), radix: 2))
    XCTAssertEqual(oxygen * co2, 2981085)
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
