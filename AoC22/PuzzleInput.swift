//
//  PuzzleInput.swift
//  AoC
//
//  Created by Mike on 26/12/2022.
//

import Foundation

struct PuzzleInput {
  
  let lines: [Substring]
  
  init(named name: String) throws {
    guard let url = Bundle(for: Day1.self).url(forResource: name, withExtension: "txt")
    else { throw CocoaError(.fileNoSuchFile) }
    
    let string = try String(contentsOf: url)
    self.lines = string.split(separator: "\n", omittingEmptySubsequences: false).dropLast()
  }
  
  /// Loads a puzzle input following the pattern `input-1.txt` etc.
  init(day: Int) throws {
    try self.init(named: "input-\(day)")
  }
  
  /// The puzzle input interpreted to be a list of integers.
  var integers: [Int] {
    lines.map { Int($0)! }
  }
}
