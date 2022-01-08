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
  
  func testPart2() throws {
    let input = try PuzzleInput(named: "input-7")
    let positions = SubPositions(input: input.lines[0])
    
    // Start at the middle
    var position = positions.mode
    var fuel = positions.totalFuelToAlign(to: position)
    
    // Search in either direction for a better solution
    var lower = positions.totalFuelToAlign(to: position - 1)
    while lower < fuel {
      position -= 1
      fuel = lower
      lower = positions.totalFuelToAlign(to: position - 1)
    }
    
    var higher = positions.totalFuelToAlign(to: position + 1)
    while higher < fuel {
      position += 1
      fuel = higher
      higher = positions.totalFuelToAlign(to: position + 1)
    }
    
    XCTAssertEqual(fuel, 100347031)
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
    
    func totalFuelToAlign(to position: Int) -> Int {
      
      let distances = positions.lazy.map {
        abs($0.distance(to: position))
      }
      
      // Fuel grows as a triangular number corresponding to distance
      let fuel = distances.map { n in
        n * (n + 1) / 2
      }
      
      return fuel.sum()
    }
  }
}
