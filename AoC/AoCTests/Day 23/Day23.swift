//
//  Day23.swift
//  AoCTests
//
//  Created by Mike on 24/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day23: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSample1() throws {
        
        // Make the cup circuit
        let game = GameState(seed: "389125467", count: 9)
        game.doMoves(100)
        
        // Turn into an answer
        let resultCups = game.cups(from: 1).dropFirst().prefix(8)
        let strings = resultCups.lazy.map { String($0.rawValue) }
        let result: String = strings.joined()
        XCTAssertEqual(result, "67384529")
    }

    func testPart1() throws {
        
        // Make the cup circuit
        let game = GameState(seed: "562893147", count: 9)
        game.doMoves(100)
                
        // Turn into an answer
        let resultCups = game.cups(from: 1).dropFirst().prefix(8)
        let strings = resultCups.lazy.map { String($0.rawValue) }
        let result: String = strings.joined()
        XCTAssertEqual(result, "38925764")
    }
    
    func testPart2() {
        
        // Make the cup circuit
        let game = GameState(seed: "562893147", count: 1000000)
        game.doMoves(10000000)
        
        let result1 = game.cup(after: 1)
        let result2 = game.cup(after: result1)
        let result = result1.rawValue * result2.rawValue
        XCTAssertEqual(result, 131152940564)
    }
    
    private class GameState {
        
        init(seed: String, count: Int) {
            
            var iterator = seed.makeIterator()
            let first = Cup(character: iterator.next()!)!
            
            self.links = [Int](unsafeUninitializedCapacity: count) { (buffer, initCount) in
                
                // Make the other cups, connecting the chain as we go along
                var previous = first
                while let valueChar = iterator.next() {
                    let next = Cup(character: valueChar)!
                    buffer[previous.index] = next.index
                    initCount += 1
                    previous = next
                }
                
                // Keep going until we've reached count
                for i in initCount + 1 ..< count {
                    buffer[previous.index] = i
                    initCount += 1
                    previous = Cup(index: i)
                }
                
                // Make the final connection back to start
                buffer[previous.index] = first.index
                initCount += 1
            }
            
            self.current = first
        }
        
        // MARK: Links
        
        /// For a cup whose `index = value - 1`, tells the index of the next cup clockwise from it.
        var links: [Int]
        
        func indexOfCup(after cup: Cup) -> Int {
            return links[cup.index]
        }
        
        func cup(after cup: Cup) -> Cup {
            return Cup(index: indexOfCup(after: cup))
        }
        
        /// Sequence that walks the cups, with `cup` as the first in the sequence.
        func cups(from cup: Cup) -> UnfoldFirstSequence<Cup> {
            return sequence(first: cup) { (cup) -> Cup? in
                return self.cup(after: cup)
            }
        }
        
        func link(from cup: Cup, to next: Cup) {
            links[cup.index] = next.index
        }
        
        // MARK: Cups
        
        /// The "current" cup.
        var current: Cup
        
        func doMove() {
            
            // Pick out the cups after the current cup
            
            let firstHeld = cup(after: current)
            let sequenceThroughNext = cups(from: firstHeld).prefix(4)
            link(from: current, to: sequenceThroughNext.last!)
            
            let sequenceToNext = sequenceThroughNext.dropLast()
            let lastHeld = sequenceToNext.last!
            
            // Figure out which cup will be the destination
            var destination = current
            repeat {
                var destinationValue = destination.rawValue - 1
                if destinationValue < 1 { destinationValue = links.count }
                destination = Cup(rawValue: destinationValue)
            } while sequenceToNext.contains(destination)
            
            // Insert the removed cups after the destination
            link(from: lastHeld, to: cup(after: destination))
            link(from: destination, to: firstHeld)
        }
        
        func doMoves(_ count: Int) {
            for _ in 1...count {
                doMove()
                // Move onto next cup
                self.current = cup(after: current)
            }
        }
    }

    struct Cup : RawRepresentable, Equatable, ExpressibleByIntegerLiteral {
        
        init(index: Int) {
            self.rawValue = index + 1
        }
        
        init(rawValue: Int) {
            precondition(rawValue >= 1)
            self.rawValue = rawValue
        }
        
        init(integerLiteral value: Int) {
            self.init(rawValue: value)
        }
        
        init?(character: Character) {
            guard let value = Int(String(character)) else { return nil }
            self.rawValue = value
        }
        
        let rawValue: Int
        
        /// The index of the cup in the linked list. i.e. value - 1
        var index: Int { rawValue - 1 }
    }
}

extension Sequence {
    
    var first: Element? {
        var iterator = makeIterator()
        return iterator.next()
    }
    
    /// - Complexity: O(n) where `n` is the length of the sequence.
    var last: Element? {
        var last: Element? = nil
        for element in self {
            last = element
        }
        return last
    }
}
