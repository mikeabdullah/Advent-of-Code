//
//  Day5.swift
//  AoC2021Tests
//
//  Created by Mike on 02/01/2022.
//

import XCTest

class Day5: XCTestCase {
  
  func testPart1() throws {
    let input = try PuzzleInput(named: "input-5")
    
    let segments = input.lines.map(LineSegment.init)
    
    var visitedPoints = Set<SIMD2<Int>>()
    var doubleVisited = Set<SIMD2<Int>>()
    
    for segment in segments where segment.isAxisAligned {
      for point in segment.points {
        if visitedPoints.contains(point) {
          doubleVisited.insert(point)
        }
        else {
          visitedPoints.insert(point)
        }
      }
    }
    
    XCTAssertEqual(doubleVisited.count, 8622)
  }
  
  func testPart2() throws {
    let input = try PuzzleInput(named: "input-5")
    
    let segments = input.lines.map(LineSegment.init)
    
    var visitedPoints = Set<SIMD2<Int>>()
    var doubleVisited = Set<SIMD2<Int>>()
    
    for segment in segments {
      for point in segment.points {
        if visitedPoints.contains(point) {
          doubleVisited.insert(point)
        }
        else {
          visitedPoints.insert(point)
        }
      }
    }
    
    XCTAssertEqual(doubleVisited.count, 22037)
  }
  
  struct LineSegment {
    
    init(start: SIMD2<Int>, end: SIMD2<Int>) {
      self.start = start
      self.end = end
    }
    
    init<S>(string: S) where S : StringProtocol {
      let comps = string.components(separatedBy: " -> ")
      self.start = SIMD2(from: comps[0])
      self.end = SIMD2(from: comps[1])
    }

    var start: SIMD2<Int>
    var end: SIMD2<Int>
    
    /// The points that a  line passes through.
    var points: [SIMD2<Int>] {
      
      if start.x == end.x {
        return stride(from: min(start.y, end.y), through: max(start.y, end.y), by: 1).map {
          SIMD2(x: start.x, y: $0)
        }
      }
      else if start.y == end.y {
        return stride(from: min(start.x, end.x), through: max(start.x, end.x), by: 1).map {
          SIMD2(x: $0, y: start.y)
        }
      }
      else {
        let tuples = zip(stride(from: start.x, through: end.x, by: end.x > start.x ? 1 : -1),
                         stride(from: start.y, through: end.y, by: end.y > start.y ? 1 : -1))
        return tuples.map { x, y in
          SIMD2(x: x, y: y)
        }
      }
    }
    
    var isAxisAligned: Bool {
      start.x == end.x || start.y == end.y
    }
  }
}


extension SIMD2 where Scalar == Int {
  
  public init<S>(from string: S) where S : StringProtocol {
    let comps = string.split(separator: ",", maxSplits: 1)
    self.init(x: Int(comps[0])!, y: Int(comps[1])!)
  }
}
