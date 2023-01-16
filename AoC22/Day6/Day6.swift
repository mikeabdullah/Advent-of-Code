//
//  Day6.swift
//  AoC
//
//  Created by Mike on 16/01/2023.
//

import XCTest
import Algorithms

final class Day6: XCTestCase {
  
  func testPart1Example1() {
    let input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
    XCTAssertEqual(input.offsetOfFirstStartOfPacketMarker(), 7)
  }
  
  func testPart1Example2() {
    let input = "bvwbjplbgvbhsrlpgdmjqwftvncz"
    XCTAssertEqual(input.offsetOfFirstStartOfPacketMarker(), 5)
  }
  
  func testPart1Example3() {
    let input = "nppdvjthqldpwncqszvftbrmjlhg"
    XCTAssertEqual(input.offsetOfFirstStartOfPacketMarker(), 6)
  }
  
  func testPart1Example4() {
    let input = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
    XCTAssertEqual(input.offsetOfFirstStartOfPacketMarker(), 10)
  }
  
  func testPart1Example5() {
    let input = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
    XCTAssertEqual(input.offsetOfFirstStartOfPacketMarker(), 11)
  }
  
  func testPart1() throws {
    let input = try PuzzleInput(day: 6).lines[0]
    XCTAssertEqual(input.offsetOfFirstStartOfPacketMarker(), 1100)
  }
  
  func testPart2() throws {
    let input = try PuzzleInput(day: 6).lines[0]
    XCTAssertEqual(input.offsetOfFirstStartOfMessageMarker(), 2421)
  }
}

extension StringProtocol {
  
  func offsetOfFirstStartOfPacketMarker() -> Int? {
    let windows = self.windows(ofCount: 4)
    var characterCounts = CountedSet<Character>(self.prefix(3))
    
    // Look for a range where all characters are unique
    for (n, window) in windows.enumerated() {
      // Include the new character, prepare to move on to the next window
      characterCounts.insert(window.last!)
      defer { characterCounts.remove(window.first!) }
      
      if characterCounts.count == 4 {
        return n + 4
      }
    }
    
    return nil
  }
  
  func offsetOfFirstStartOfMessageMarker() -> Int? {
    let windows = self.windows(ofCount: 14)
    var characterCounts = CountedSet<Character>(self.prefix(13))
    
    // Look for a range where all characters are unique
    for (n, window) in windows.enumerated() {
      // Include the new character, prepare to move on to the next window
      characterCounts.insert(window.last!)
      defer { characterCounts.remove(window.first!) }
      
      if characterCounts.count == 14 {
        return n + 14
      }
    }
    
    return nil
  }
}
