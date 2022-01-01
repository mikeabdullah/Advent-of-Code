//
//  Day4.swift
//  AoC2021Tests
//
//  Created by Mike on 01/01/2022.
//

import XCTest

class Day4: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testPart1() throws {
    let input = try PuzzleInput(named: "input-4")
    
    // Build the boards
    let boardLines = input.lines.dropFirst(2).split(separator: "")
    let boards = boardLines.map(Board.init)
    
    // Let's play!
    var drawnNumbers = Set<Int>()
    for drawn in input.lines[0].split(separator: ",") {
      let number = Int(drawn)!
      XCTAssertTrue(drawnNumbers.insert(number).inserted, "Any one number should only be drawn once")
      
      // See if any boards are complete
      guard let completed = boards.first(where: { $0.isComplete(for: drawnNumbers) }) else {
        continue
      }
      
      let unmarkedNumbers = completed.numbers.joined().lazy.filter { !drawnNumbers.contains($0) }
      XCTAssertEqual(unmarkedNumbers.sum() * number, 16674)
      return
    }
  }
  
  struct Board {
    
    init(rows: ArraySlice<Substring>) {
      numbers = rows.map { row in
        let rowNumbers = row.split(separator: " ", omittingEmptySubsequences: true)
        return rowNumbers.map { Int($0)! }
      }
    }
    
    let numbers: [[Int]]
    
    /// Returns the number at a given coordinate.
    /// - Complexity: O(1)
    subscript(x: Int, y: Int) -> Int {
      numbers[y][x]
    }
    
    /// Checks if the board has a complete row, column, or diagonal for the given input.
    func isComplete(for drawnNumbers: Set<Int>) -> Bool {
      
      let range = 0..<5
      
      // Check if a diagonal is filled
      if range.allSatisfy({ n in drawnNumbers.contains(self[n,n])})
          || range.allSatisfy({ n in drawnNumbers.contains(self[4-n,n])}) {
        return true
      }
        
      // Look for a row or column where all the numbers have been drawn
      return range.contains { n in
        range.allSatisfy { drawnNumbers.contains(self[n,$0]) }
        || range.allSatisfy{ drawnNumbers.contains(self[$0,n]) }
      }
    }
  }
}
