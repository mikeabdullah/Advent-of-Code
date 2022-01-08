//
//  Day7.swift
//  AoC2021Tests
//
//  Created by Mike on 08/01/2022.
//

import XCTest

class Day7: XCTestCase {
  
  func testPart1() throws {
    let input = try PuzzleInput(named: "input-7")
    let positions = SubPositions(input: input.lines[0])
    
    // Find the middle
    XCTAssertEqual(positions.mode, 361)
    XCTAssertEqual(positions.totalDistanceToAlign(to: positions.mode), 356922)
  }
  
  struct SubPositions {
    
    init<S>(input: S) where S : StringProtocol {
      self.positions = input.lazy.split(separator: ",").map { Int($0)! }.sorted()
    }
    
    let positions: [Int]
    
    var mode: Int {
      let mid1 = positions.endIndex / 2
      let mid2 = (positions.endIndex + 1) / 2
      return (positions[mid1] + positions[mid2]) / 2
    }
    
    func totalDistanceToAlign(to position: Int) -> Int {
      let adjustments = positions.lazy.map {
        abs($0.distance(to: position))
      }
      return adjustments.sum()
    }
  }
}
