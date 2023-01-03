//
//  Day3.swift
//  AoC
//
//  Created by Mike on 02/01/2023.
//

import XCTest

final class Day3: XCTestCase {
  
  func testPart1() throws {
    let input = try PuzzleInput(day: 3)
    
    let rucksacks = input.lines.map { contentsString in
      Rucksack(contents: contentsString)
    }
    
    var total = 0
    for rucksack in rucksacks {
      let firstSet = Set(rucksack.firstCompartment)
      let secondSet = Set(rucksack.secondCompartment)
      for item in firstSet.intersection(secondSet) {
        total += Int(item)
      }
    }
    
    XCTAssertEqual(total, 8240)
  }
  
  struct Rucksack {
    
    init(contents: Substring) {
      self.contents = contents.utf8.map { itemType in
        if itemType >= 97 {
          return itemType - 97 + 1  // 97 = a in unicode
        } else {
          return itemType - 65 + 27 // 65 = A in unicode
        }
      }
    }
    
    let contents: [UTF8Char]
    
    var firstCompartment: ArraySlice<UTF8Char> {
      contents.prefix(upTo: contents.count / 2)
    }
    
    var secondCompartment: ArraySlice<UTF8Char> {
      contents.suffix(from: contents.count / 2)
    }
    
    var compartments: (first: ArraySlice<UTF8Char>, second: ArraySlice<UTF8Char>) {
      (firstCompartment, secondCompartment)
    }
  }
}
