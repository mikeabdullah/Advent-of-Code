//
//  AoC2021Tests.swift
//  AoC2021Tests
//
//  Created by Mike on 29/12/2021.
//

import XCTest

class Day1: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testPart1() throws {
    let input = try PuzzleInput(named: "input1")
   
    var increases = 0
    var window = input.integers.slidingWindow(length: 2)
    
    repeat {
      if window[0] < window[1] {
        increases += 1
      }
    } while window.advance()
    
    XCTAssertEqual(increases, 1564)
  }
  
  func testPart2() throws {
    let input = try PuzzleInput(named: "input1")
    
    var window = input.integers.slidingWindow(length: 3)
    var previousSum = window.sum()
    var increases = 0
    
    while window.advance() {
      let sum = window.sum()
      if sum > previousSum { increases += 1 }
      previousSum = sum
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


extension Sequence where Element : AdditiveArithmetic {
  
  func sum() -> Element {
    return reduce(.zero) { (result, element) in
      result + element
    }
  }
}
