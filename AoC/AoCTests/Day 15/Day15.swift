//
//  Day15.swift
//  AoCTests
//
//  Created by Mike on 03/01/2021.
//  Copyright © 2021 Mike Abdullah. All rights reserved.
//

import XCTest

class Day15: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSample036() {
        let game = Game(startingNumbers: [0, 3, 6])
        
        XCTAssertEqual(game.speakNext(), 0)
        XCTAssertEqual(game.speakNext(), 3)
        XCTAssertEqual(game.speakNext(), 3)
        XCTAssertEqual(game.speakNext(), 1)
        XCTAssertEqual(game.speakNext(), 0)
        XCTAssertEqual(game.speakNext(), 4)
        XCTAssertEqual(game.speakNext(), 0)
        
        XCTAssertEqual(game.speak(turn: 2020), 436)
    }
    
    func testSample132() {
        let game = Game(startingNumbers: [1, 3, 2])
        XCTAssertEqual(game.speak(turn: 2020), 1)
    }
    
    func testSample213() {
        let game = Game(startingNumbers: [2, 1, 3])
        XCTAssertEqual(game.speak(turn: 2020), 10)
    }
    
    func testSample123() {
        let game = Game(startingNumbers: [1, 2, 3])
        XCTAssertEqual(game.speak(turn: 2020), 27)
    }
    
    func testSample231() {
        let game = Game(startingNumbers: [2, 3, 1])
        XCTAssertEqual(game.speak(turn: 2020), 78)
    }
    
    func testSample321() {
        let game = Game(startingNumbers: [3, 2, 1])
        XCTAssertEqual(game.speak(turn: 2020), 438)
    }
    
    func testSample312() {
        let game = Game(startingNumbers: [3, 1, 2])
        XCTAssertEqual(game.speak(turn: 2020), 1836)
    }
    
    // MARK: Real
    
    func testPart1() {
        let game = Game(startingNumbers: [2,15,0,9,1,20])
        XCTAssertEqual(game.speak(turn: 2020), 1280)
    }
    
    func testPart2() {
        let game = Game(startingNumbers: [2,15,0,9,1,20])
        game.reserveCapacity(30000000)
        XCTAssertEqual(game.speak(turn: 30000000), 651639)
    }
    
    class Game {
        
        init(startingNumbers: [Int]) {
            precondition(!startingNumbers.isEmpty)
            startingNumbers.forEach(appendTurn)
        }
        
        // MARK: Turns
        
        /// The turn we're currently on, and its number
        private var currentTurn: Int = 0
        private var currentNumber: Int?
        
        private var numbersByLastTurn: [Int : Int] = [:]
        
        /// Stores the next turn.
        private func appendTurn(_ number: Int) {
            if let current = currentNumber {
                numbersByLastTurn[current] = currentTurn
            }
            self.currentTurn += 1
            self.currentNumber = number
        }
        
        func reserveCapacity(_ minimumCapacity: Int) {
            numbersByLastTurn.reserveCapacity(minimumCapacity)
        }
        
        // MARK: Running the Game
        
        /// Figures out the next number to speak and appends it to the spoken list.
        @discardableResult
        func speakNext() -> Int {
            
            let next = self.age(of: currentNumber!)
            appendTurn(next)
            return next
        }
        
        /// How many turns ago was `number` last spoken? 0 if not yet spoken.
        private func age(of number: Int) -> Int {
            guard let previous = numbersByLastTurn[number] else {
                return 0
            }
            let age = self.currentTurn - previous
            assert(age > 0)
            return age
        }
        
        /// Advances the game to at least the specified turn and returns the number for that turn. Tuns are 1-based.
        func speak(turn: Int) -> Int {
            
            while currentTurn < turn {
                speakNext()
            }
            
            return currentNumber!
        }
    }
}
