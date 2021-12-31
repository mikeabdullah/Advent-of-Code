//
//  AoC2021Tests.swift
//  AoC2021Tests
//
//  Created by Mike on 29/12/2021.
//

import XCTest
import Algorithms

class Day1: XCTestCase {
  
  func testPart1() throws {
    let input = try PuzzleInput(named: "input-1")
    let increases = input.integers.adjacentPairs().count(where: <)
    XCTAssertEqual(increases, 1564)
  }
  
  func testPart2() throws {
    let input = try PuzzleInput(named: "input-1")
    
    // For each pair of sliding windows, all that really matters is how the first and last elements
    // differ, so can use a single sliding window with four elements, comparing the first and last
    // https://alpha.danieltull.co.uk/aoc/2021-12-01/
    let windows = input.integers.windows(ofCount: 4)
    let increases = windows.count { window in
      window.last! > window.first!
    }
    
    XCTAssertEqual(increases, 1611)
  }
}


struct PuzzleInput {
  
  let lines: [Substring]
  
  init(named name: String) throws {
    guard let url = Bundle(for: Day1.self).url(forResource: name, withExtension: "txt")
    else { throw CocoaError(.fileNoSuchFile) }
    
    let string = try String(contentsOf: url)
    self.lines = string.split(separator: "\n")
  }
  
  /// The puzzle input interpreted to be a list of integers.
  var integers: [Int] {
    lines.map { Int($0)! }
  }
}

extension Collection where Element : Collection {
  
  /// Accesses the elements in a columnar layout, instead of by row.
  subscript(column column: Int) -> LazyMapSequence<Self, Element.Element> {
    self.lazy.map { row in
      row[row.index(row.startIndex, offsetBy: column)]
    }
  }
}

struct SlidingWindow<Base> : Collection where Base : Collection {
  
  /// The collection being slid over.
  private(set) var slice: Slice<Base>
  
  // MARK: Collection
  
  var startIndex: Int { 0 }
  var endIndex: Int { slice.count }
  
  func index(after i: Int) -> Int {
    i + 1
  }
  
  subscript(position: Int) -> Base.Element {
    return slice.base[slice.index(slice.startIndex, offsetBy: position)]
  }
  
  // MARK: Adjusting the Window
  
  /// Advances the window a given number of times, unless already at the end.
  mutating func advance(by offset: Int = 1) -> Bool {
    guard slice.endIndex < slice.base.endIndex else { return false }
    
    slice = Slice(base: slice.base,
                  bounds: slice.index(slice.startIndex, offsetBy: offset)..<slice.index(slice.endIndex, offsetBy: offset))
    return true
  }
}

extension Collection {
  
  /// Creates a sliding window starting at the beginning of the collection, containing _length_ elements.
  func slidingWindow(length: Int) -> SlidingWindow<Self> {
    let slice = Slice(base: self, bounds: startIndex..<index(startIndex, offsetBy: length))
    return SlidingWindow(slice: slice)
  }
}

extension Sequence {
  
  /// Convenience to find how many elements of the sequence match `predicate`.
  func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
    try lazy.filter(predicate).count
  }
}

extension Sequence where Element : AdditiveArithmetic {
  
  func sum() -> Element {
    return reduce(.zero) { (result, element) in
      result + element
    }
  }
}
