//
//  Day2.swift
//  AoC
//
//  Created by Mike on 26/12/2022.
//

import XCTest

final class Day2: XCTestCase {
  
  enum HandShape: Int {
    case rock = 1
    case paper = 2
    case scissors = 3
    
    init?<S>(opponentChoice: S) where S : StringProtocol {
      switch opponentChoice {
      case "A": self = .rock
      case "B": self = .paper
      case "C": self = .scissors
      default: return nil
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
    
    func choice(for outcome: Outcome) -> HandShape {
      switch (self, outcome) {
      case (.rock, .win): return .paper
      case (.paper, .win): return .scissors
      case (.scissors, .win): return .rock
        
      case (.rock, .draw): return .rock
      case (.paper, .draw): return .paper
      case (.scissors, .draw): return .scissors
        
      case (.rock, .lose): return .scissors
      case (.paper, .lose): return .rock
      case (.scissors, .lose): return .paper
      }
    }
  }
  
  enum Outcome: Int {
    case win = 6
    case draw = 3
    case lose = 0
    
    init?<S>(guideValue: S) where S : StringProtocol {
      switch guideValue {
      case "X": self = .lose
      case "Y": self = .draw
      case "Z": self = .win
      default: return nil
      }
    }
  }
  
  /// A single line from the guideline.
  struct GuideLine1 {
    
    let opponentChoice: HandShape
    let ownChoice: HandShape
    
    init<S>(_ string: S) where S : StringProtocol {
      let sides = string.split(separator: " ")
      
      self.opponentChoice = HandShape(opponentChoice: sides[0])!
      
      switch sides[1] {
      case "X": self.ownChoice = .rock
      case "Y": self.ownChoice = .paper
      case "Z": self.ownChoice = .scissors
      default: fatalError("Unknown choice")
      }
    }
  }
  
  /// A single line from the guideline.
  struct GuideLine2 {
    
    let opponentChoice: HandShape
    let outcome: Outcome
    
    init<S>(_ string: S) where S : StringProtocol {
      let sides = string.split(separator: " ")
      self.opponentChoice = HandShape(opponentChoice: sides[0])!
      self.outcome = Outcome(guideValue: sides[1])!
    }
  }
  
  func testPart1() throws {
    
    let input = try PuzzleInput(day: 2)
    let lines = input.lines.map { GuideLine1($0) }
    
    var score = 0
    for line in lines {
      score += line.ownChoice.rawValue
      score += line.ownChoice.outcome(against: line.opponentChoice).rawValue
    }
    
    XCTAssertEqual(score, 11063)
  }
  
  func testPart2() throws {
    
    let input = try PuzzleInput(day: 2)
    let lines = input.lines.map { GuideLine2($0) }
    
    var score = 0
    for line in lines {
      score += line.outcome.rawValue
      let ownChoice = line.opponentChoice.choice(for: line.outcome)
      score += ownChoice.rawValue
    }
    
    XCTAssertEqual(score, 10349)
  }
}
