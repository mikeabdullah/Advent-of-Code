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
    
    XCTAssertEqual(simulation.numberOfFish, 1686252324092)
  }
  
  struct FishSimulation {
    
    init(input: PuzzleInput) {
      let timerValues = input.lines[0].lazy.split(separator: ",").map { Int($0)! }
      
      self.timerValues = timerValues.reduce(into: Array(repeating: 0, count: 9)) { partialResult, value in
        partialResult[value] += 1
      }
      XCTAssertEqual(self.numberOfFish, timerValues.count)
    }
    
    /// Each index in ths array corresponds to a timer value, and contains the number of fish that currently have that timer.
    private var timerValues: [Int]
    
    var numberOfFish: Int { timerValues.sum() }
    
    /// Simulates a single day's lifecycle
    mutating func performSimulation() {
      
      // Each day the fish's timers tick down. Any 0's become 6, and add another 8 to the list
      let spawners = timerValues.removeFirst()
      timerValues[6] += spawners
      timerValues.append(spawners)
    }
  }
}
