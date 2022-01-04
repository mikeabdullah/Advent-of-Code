//
//  Day6.swift
//  AoC2021Tests
//
//  Created by Mike on 04/01/2022.
//

import XCTest

class Day6: XCTestCase {
  
  func testPart1() throws {
    let input = try PuzzleInput(named: "input-6")
    
    var timers: [Int] = input.lines[0].lazy.split(separator: ",").map { Int($0)! }
    
    for _ in 1...80 {
      // Each day the fish's timers tick down. Any 0's become 6, and add another 8 to the list
      for index in timers.indices {
        if timers[index] == 0 {
          timers[index] = 6
          timers.append(8)
        }
        else {
          timers[index] -= 1
        }
      }
    }
    
    XCTAssertEqual(timers.count, 374994)
  }
}
