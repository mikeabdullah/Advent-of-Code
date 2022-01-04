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
    simulation.simulate(until: 80)
    XCTAssertEqual(simulation.numberOfFish, 374994)
  }
  
  func testPart2() throws {
    let input = try PuzzleInput(named: "input-6")
    
    var simulation = FishSimulation(input: input)
    simulation.simulate(until: 256)
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
    
    /// The day of the simulation we're currently on.
    private(set) var day = 0
    
    /// Simulates a single day's lifecycle
    mutating func performSimulation() {
      
      // Each day the fish's timers tick down. Any 0's become 6, and add another 8 to the list
      timerValues.rotate(toStartAt: 1)  // the 0 timer fish have effectively become new fish with a value of 8
      timerValues[6] += timerValues[8]
      self.day += 1
    }
    
    /// Performs a number of simulations until the desired day is reached.
    mutating func simulate(until day: Int) {
      while self.day < day {
        self.performSimulation()
      }
    }
  }
}
