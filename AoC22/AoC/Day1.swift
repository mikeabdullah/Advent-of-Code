//
//  AoC.swift
//  AoC
//
//  Created by Mike on 26/12/2022.
//

import XCTest

final class Day1: XCTestCase {
  
  func testPart1() throws {
    let input = try PuzzleInput(day: 1).lines
    let batches = input.split(separator: "")
    
    let calories = batches.lazy.map { calorieCounts in
      calorieCounts.lazy.map { Int($0)! }.reduce(0, +)
    }
    
    let highest = calories.max()!
    XCTAssertEqual(highest, 74711)
  }
  
  func testPart2() throws {
    let input = try PuzzleInput(day: 1).lines
    let batches = input.split(separator: "")
    
    let calories = batches.lazy.map { calorieCounts in
      calorieCounts.lazy.map { Int($0)! }.reduce(0, +)
    }.sorted(by: >) // highest calories first
    
    let topThreeTotal = calories.prefix(3).reduce(0, +)
    XCTAssertEqual(topThreeTotal, 209481)
  }
}
