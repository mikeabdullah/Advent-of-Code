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
        var game = GameState(startingNumbers: [0, 3, 6])
        
        XCTAssertEqual(game.speakNext(), 0)
        XCTAssertEqual(game.speakNext(), 3)
        XCTAssertEqual(game.speakNext(), 3)
        XCTAssertEqual(game.speakNext(), 1)
        XCTAssertEqual(game.speakNext(), 0)
        XCTAssertEqual(game.speakNext(), 4)
        XCTAssertEqual(game.speakNext(), 0)
        
        XCTAssertEqual(game.speak(turn: 2020), 436)
    }
    
    
    struct GameState {
        
        init(startingNumbers: [Int]) {
            precondition(!startingNumbers.isEmpty)
            self.spoken = startingNumbers
        }
        
        /// The numbers which have been spoken so far in the game.
        private(set) var spoken: [Int]
        
        /// Figures out the next number to speak and appends it to the spoken list.
        @discardableResult
        mutating func speakNext() -> Int {
            
            let last = spoken.last!
            
            // Was the number spoken before that?
            let allButLast = spoken.dropLast()
            guard let previousIndex = allButLast.lastIndex(of: last) else {
                spoken.append(0)
                return 0
            }
            
            let age = spoken.distance(from: previousIndex, to: allButLast.endIndex)
            spoken.append(age)
            return age
        }
        
        /// Advances the game to at least the specified turn and returns the number for that turn. Tuns are 1-based.
        mutating func speak(turn: Int) -> Int {
            
            while spoken.count < turn {
                speakNext()
            }
            
            return spoken[turn - 1]
        }
    }
}
