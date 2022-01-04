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
    
    var simulation = FishSimulation(input: input)

    for _ in 1...80 {
      simulation.performSimulation()
    }
    
    XCTAssertEqual(simulation.numberOfFish, 374994)
  }
  
  func testPart2() throws {
    let input = try PuzzleInput(named: "input-6")
    
    var simulation = FishSimulation(input: input)
    
    for _ in 1...256 {
      simulation.performSimulation()
    }
    
    XCTAssertEqual(simulation.numberOfFish, 374994)
  }
  
  struct FishSimulation {
    
    init(input: PuzzleInput) {
      self.timerValues = input.lines[0].lazy.split(separator: ",").map { Int($0)! }
    }
    
    /// The internal timers of each fish.
    private var timerValues: [Int]
    
    var numberOfFish: Int { timerValues.count }
    
    /// Simulates a single day's lifecycle
    mutating func performSimulation() {
      // Each day the fish's timers tick down. Any 0's become 6, and add another 8 to the list
      for index in timerValues.indices {
        if timerValues[index] == 0 {
          timerValues[index] = 6
          timerValues.append(8)
        }
        else {
          timerValues[index] -= 1
        }
      }
    }
  }
}
