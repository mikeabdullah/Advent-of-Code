//
//  Day2.swift
//  AoC2021Tests
//
//  Created by Mike on 30/12/2021.
//

import XCTest

class Day2: XCTestCase {
  
  func testPart1() throws {
    let input = try PuzzleInput(named: "input-2")
    let commands = try input.lines.map { try Command(string: $0) }
    
    var position = 0
    var depth = 0
    
    for command in commands {
      switch command {
      case let .forward(forward): position += forward
      case let .down(down): depth += down
      }
    }
    
    XCTAssertEqual(position * depth, 1690020)
  }
  
  func testPart2() throws {
    let input = try PuzzleInput(named: "input-2")
    let commands = try input.lines.map { try Command(string: $0) }
    
    var position = 0
    var depth = 0
    var aim = 0
    
    for command in commands {
      switch command {
      case let .down(down):
        aim += down
      case let .forward(x):
        position += x
        depth += aim * x
      }
    }
    
    XCTAssertEqual(position * depth, 1408487760)
  }
  
  enum Command {
    case forward(Int)
    case down(Int)
    
    init<S>(string: S) throws where S : StringProtocol {
      let comps = string.split(separator: " ")
      guard let quantity = Int(comps[1]) else { throw CocoaError(.fileReadCorruptFile) }
      switch comps[0] {
      case "forward": self = .forward(quantity)
      case "down": self = .down(quantity)
      case "up": self = .down(-quantity)
      default: throw CocoaError(.fileReadCorruptFile)
      }
    }
  }
}
