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
        var game = GameState("389125467", count: 9)
        game.doMoves(100)
        
        // Turn into an answer
        let resultCups = game.cups[1]!.next.sequenceClockwise().prefix(8)
        let values = resultCups.lazy.map { $0.value }
        let strings = values.lazy.map { String($0) }
        let result: String = strings.joined()
        XCTAssertEqual(result, "67384529")
    }

    func testPart1() throws {
        
        // Make the cup circuit
        var game = GameState("562893147", count: 9)
        game.doMoves(100)
                
        // Turn into an answer
        let resultCups = game.cups[1]!.next.sequenceClockwise().prefix(8)
        let values = resultCups.lazy.map { $0.value }
        let strings = values.lazy.map { String($0) }
        let result: String = strings.joined()
        XCTAssertEqual(result, "38925764")
    }
    
    func testPart2() {
        
        // Make the cup circuit
        var game = GameState("562893147", count: 1000000)
        game.doMoves(10000000)
    }
    
    private struct GameState {
        
        init(_ string: String, count: Int) {
            
            var cups = [Int:Cup]()
            cups.reserveCapacity(count)
            
            self.current = Cup(value: Int(String(string.first!))!)
            cups[current.value] = current
            
            // Make the other cups, connecting the chain as we go along
            var previous = current
            for valueChar in string.dropFirst() {
                let value = Int(String(valueChar))!
                let cup = Cup(value: value)
                cups[value] = cup
                previous.next = cup
                previous = cup
            }
            
            // Keep going until we've reached count
            for i in cups.count+1 ..< count+1 {
                let cup = Cup(value: i)
                cups[i] = cup
                previous.next = cup
                previous = cup
            }
            
            // Make the final connection back to start
            previous.next = current
            
            self.cups = cups
        }
        
        /// All cups in the game.
        let cups: [Int:Cup]
        
        /// The "current" cup.
        var current: Cup
        
        func doMove() {
            
            // Pick out the cups after the current cup
            let held = current.removeNext(3)
            let heldValues = held.sequenceClockwise().lazy.map { $0.value }
            
            // Find the destination
            var destinationValue = current.value
            repeat {
                destinationValue -= 1
                if destinationValue < 1 { destinationValue = 9 }
            } while heldValues.contains(destinationValue)
            let destination = current.sequenceClockwise().first(where: { $0.value == destinationValue })!
            
            // Insert the removed cups
            destination.insert(held)
        }
        
        mutating func doMoves(_ count: Int) {
            for _ in 1...count {
                doMove()
                // Move onto next cup
                current = current.next
            }
        }
    }

    class Cup {
        
        init(value: Int, next: Cup? = nil) {
            self.value = value
            self.next = next
        }
        
        let value: Int
        
        /// The next cup in the clockwise direction
        var next: Cup!
        
        /// Sequence that walks the cups until one is nil (so typically forever)
        func sequenceClockwise() -> UnfoldFirstSequence<Cup> {
            return sequence(first: self) { $0.next }
        }
        
        func insert(_ cup: Cup) {
            let next = self.next
            self.next = cup
            cup.sequenceClockwise().last!.next = next
        }
        
        /// Removes the _k_ next cups in the chain, changing `next` to point to the cup after this amount.
        func removeNext(_ k: Int) -> Cup {
            
            let next = self.next!
            var iterator = self.sequenceClockwise().dropFirst(k).makeIterator()
            
            let lastToRemove = iterator.next()!
            let replacement = iterator.next()!
            
            lastToRemove.next = nil
            self.next = replacement
            return next
        }
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
