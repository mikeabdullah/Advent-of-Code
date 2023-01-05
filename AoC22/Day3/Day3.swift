//
//  Day3.swift
//  AoC
//
//  Created by Mike on 02/01/2023.
//

import XCTest
import Algorithms

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
    let rucksackComponent = world.registerComponent(Rucksack.self)
    
    // Create an entity for each elf and its rucksack
    for contentsString in input.lines {
      let elf = world.create()
      world[rucksackComponent, for: elf] = Rucksack(contents: contentsString)
    }
    
    var total = 0
    for (_, rucksack) in world.entities(thatHave: rucksackComponent) {
      let firstSet = Set(rucksack.firstCompartment)
      let secondSet = Set(rucksack.secondCompartment)
      for item in firstSet.intersection(secondSet) {
        total += item
      }
    }
    
    XCTAssertEqual(total, 8240)
  }
  
  func testPart2() throws {
    let input = try PuzzleInput(day: 3)
        
    var total = 0
    for group in input.lines.chunks(ofCount: 3) {
      // Find the items in common within the group
      // Shouldn't need to make a temp set, but something's going wrong without
      var commonItems = Set(group.first!.unicodeScalars)
      for contentsString in group.dropFirst() {
        commonItems.formIntersection(Set(contentsString.unicodeScalars))
      }
      assert(commonItems.count == 1, "There's only supposed to be one item on common")
      total += commonItems.first!.priority
    }
    
    XCTAssertEqual(total, 2587)
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
