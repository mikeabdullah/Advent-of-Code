//
//  Day5.swift
//  AoC
//
//  Created by Mike on 08/01/2023.
//

import XCTest
import RegexBuilder

final class Day5: XCTestCase {
  
  func testPart1() throws {
    // Load the start state from the input
    let input = try PuzzleInput(day: 5)
    let separatorLine = input.lines.firstIndex(of: "")!
    var stacks = input.stacks(upTo: separatorLine)
    
    // Perform the moves
    for line in input.lines.suffix(from: separatorLine + 1) {
      let scanner = Scanner(string: String(line))
      _ = scanner.scanString("move")
      let numberToMove = scanner.scanInt()!
      _ = scanner.scanString("from")
      let fromStack = scanner.scanInt()! - 1
      _ = scanner.scanString("to")
      let toStack = scanner.scanInt()! - 1
      
      for _ in 0..<numberToMove {
        let crate = stacks[fromStack].removeLast()
        stacks[toStack].append(crate)
      }
    }
    
    // Get top of each stack
    let top = String(stacks.lazy.map { stack in
      stack.last!
    })
    XCTAssertEqual(top, "TWSGQHNHL")
  }
  
  func testPart2() throws {
    // Load the start state from the input
    let input = try PuzzleInput(day: 5)
    let separatorLine = input.lines.firstIndex(of: "")!
    var stacks = input.stacks(upTo: separatorLine)
    
    // Perform the moves
    for line in input.lines.suffix(from: separatorLine + 1) {
      let scanner = Scanner(string: String(line))
      _ = scanner.scanString("move")
      let numberToMove = scanner.scanInt()!
      _ = scanner.scanString("from")
      let fromStack = scanner.scanInt()! - 1
      _ = scanner.scanString("to")
      let toStack = scanner.scanInt()! - 1
      
      // Effectively move all crates while retaining order
      stacks[toStack].append(contentsOf: stacks[fromStack].suffix(numberToMove))
      stacks[fromStack].removeLast(numberToMove)
    }
    
    // Get top of each stack
    let top = String(stacks.lazy.map { stack in
      stack.last!
    })
    XCTAssertEqual(top, "JNRSCDWPP")
  }
}

private extension PuzzleInput {
  
  func stacks(upTo index: Int) -> [[Character]] {
    let cratesInput = lines.prefix(upTo: index)
    let stackCount = (cratesInput.last!.count + 1) / 4
    var stacks = Array(repeating: [Character](), count: stackCount)
    
    for line in cratesInput.dropLast() {
      for (index, crate) in line.dropFirst().striding(by: 4).enumerated() where crate != " " {
        stacks[index].append(crate)
      }
    }
    
    return stacks.map { $0.reversed() }
  }
}
