//
//  Day4.swift
//  AoC
//
//  Created by Mike on 05/01/2023.
//

import XCTest

final class Day4: XCTestCase {
  
  func testPart1() throws {
    let input = try PuzzleInput(day: 4)
    
    var total = 0
    for line in input.lines {
      let pair = ElfPair(line: line)
      if pair.range1.fullyContains(pair.range2) || pair.range2.fullyContains(pair.range1) {
        total += 1
      }
    }
    
    XCTAssertEqual(total, 485)
  }
  
  func testPart2() throws {
    let input = try PuzzleInput(day: 4)
    
    var total = 0
    for line in input.lines {
      let pair = ElfPair(line: line)
      if pair.range1.overlaps(pair.range2) {
        total += 1
      }
    }
    
    XCTAssertEqual(total, 857)
  }
  
  struct ElfPair {
    
    init<S: StringProtocol>(line: S) {
      let sections = line.split(separator: ",").map { range in
        let separator = range.firstIndex(of: "-")!
        let start = Int(range.prefix(upTo: separator))!
        let end = Int(range.suffix(from: range.index(after: separator)))!
        return start...end
      }
      
      range1 = sections[0]
      range2 = sections[1]
    }
    
    let range1: ClosedRange<Int>
    let range2: ClosedRange<Int>
  }
}

extension ClosedRange {
  
  func fullyContains(_ other: ClosedRange) -> Bool {
    self.contains(other.lowerBound) && self.contains(other.upperBound)
  }
}
