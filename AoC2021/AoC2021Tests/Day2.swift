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
      position += command.positionChange
      depth += command.depthChange
    }
    
    XCTAssertEqual(position * depth, 1690020)
  }
  
  enum Command {
    case forward(Int)
    case down(Int)
    case up(Int)
    
    init<S>(string: S) throws where S : StringProtocol {
      let comps = string.split(separator: " ")
      guard let quantity = Int(comps[1]) else { throw CocoaError(.fileReadCorruptFile) }
      switch comps[0] {
      case "forward": self = .forward(quantity)
      case "down": self = .down(quantity)
      case "up": self = .up(quantity)
      default: throw CocoaError(.fileReadCorruptFile)
      }
    }
    
    var depthChange: Int {
      switch self {
      case .forward: return 0
      case .down(let down): return down
      case .up(let up): return -up
      }
    }
    
    var positionChange: Int {
      switch self {
      case .forward(let forwards): return forwards
      case .up, .down: return 0
      }
    }
  }
}
