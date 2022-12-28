//
//  Day2.swift
//  AoC
//
//  Created by Mike on 26/12/2022.
//

import XCTest

final class Day2: XCTestCase {
  
  enum HandShape {
    case rock
    case paper
    case scissors
    
    /// The points a choice of shape is intrisically worth apparently.
    var score: Int {
      switch self {
      case .rock: return 1
      case .paper: return 2
      case .scissors: return 3
      }
    }
    
    func outcome(against other: HandShape) -> Outcome {
      switch (self, other) {
      case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
        return .win  // rock beats scissors, paper beats rock, etc.
      case (.rock, .rock), (.paper, .paper), (.scissors, .scissors):
        return .draw
      case (.rock, .paper), (.paper, .scissors), (.scissors, .rock):
        return .lose
      }
    }
  }
  
  enum Outcome: Int {
    case win = 6
    case draw = 3
    case lose = 0
  }
  
  /// A single line from the guideline.
  struct GuideLine {
    
    let opponentChoice: HandShape
    let ownChoice: HandShape
    
    init<S>(_ string: S) where S : StringProtocol {
      let sides = string.split(separator: " ")
      
      switch sides[0] {
      case "A": self.opponentChoice = .rock
      case "B": self.opponentChoice = .paper
      case "C": self.opponentChoice = .scissors
      default: fatalError("Unknown choice")
      }
      
      switch sides[1] {
      case "X": self.ownChoice = .rock
      case "Y": self.ownChoice = .paper
      case "Z": self.ownChoice = .scissors
      default: fatalError("Unknown choice")
      }
    }
  }
  
  func testPart1() throws {
    
    let input = try PuzzleInput(day: 2)
    let lines = input.lines.map { GuideLine($0) }
    
    var score = 0
    for line in lines {
      score += line.ownChoice.score
      score += line.ownChoice.outcome(against: line.opponentChoice).rawValue
    }
    
    XCTAssertEqual(score, 11063)
  }
}
