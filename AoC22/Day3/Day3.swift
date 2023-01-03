//
//  Day3.swift
//  AoC
//
//  Created by Mike on 02/01/2023.
//

import XCTest

final class Day3: XCTestCase {
  
  struct Rucksack: Component {
    
    init(contents: Substring) {
      self.contents = contents.unicodeScalars.map(\.priority)
    }
    
    let contents: [Int]
    
    var firstCompartment: ArraySlice<Int> {
      contents.prefix(upTo: contents.count / 2)
    }
    
    var secondCompartment: ArraySlice<Int> {
      contents.suffix(from: contents.count / 2)
    }
    
    var compartments: (first: ArraySlice<Int>, second: ArraySlice<Int>) {
      (firstCompartment, secondCompartment)
    }
  }
  
  func testPart1() throws {
    let input = try PuzzleInput(day: 3)
    
    let world = World()
    
    // Create an entity for each rucksack
    for contentsString in input.lines {
      let entity = world.create()
      world.set(Rucksack(contents: contentsString), for: entity)
    }
    
    var total = 0
    for (_, rucksack) in world.entities(thatHave: Rucksack.self) {
      let firstSet = Set(rucksack.firstCompartment)
      let secondSet = Set(rucksack.secondCompartment)
      for item in firstSet.intersection(secondSet) {
        total += item
      }
    }
    
    XCTAssertEqual(total, 8240)
  }
}

private extension UnicodeScalar {
  
  var priority: Int {
    if properties.isLowercase {
      return Int(value) - 97 + 1  // 97 = a in unicode
    } else if properties.isUppercase {
      return Int(value) - 65 + 27 // 65 = A in unicode
    } else {
      preconditionFailure("Unsupported item type")
    }
  }
}
