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
        var (cups, currentCup) = makeCups("389125467", count: 9)
                
        for _ in 1...100 {
            makeMove(currentCup: currentCup)
            // Move onto next cup
            currentCup = currentCup.next
        }
        
        // Turn into an answer
        let resultCups = cups[1]!.next.makeSequence().prefix(8)
        let values = resultCups.lazy.map { $0.value }
        let strings = values.lazy.map { String($0) }
        let result: String = strings.joined()
        XCTAssertEqual(result, "67384529")
    }

    func testPart1() throws {
        
        // Make the cup circuit
        var (cups, currentCup) = makeCups("562893147", count: 9)
                
        for _ in 1...100 {
            makeMove(currentCup: currentCup)
            // Move onto next cup
            currentCup = currentCup.next
        }
        
        // Turn into an answer
        let resultCups = cups[1]!.next.makeSequence().prefix(8)
        let values = resultCups.lazy.map { $0.value }
        let strings = values.lazy.map { String($0) }
        let result: String = strings.joined()
        XCTAssertEqual(result, "38925764")
    }
    
    private func makeCups(_ string: String, count: Int) -> (cups: [Int:Cup], current: Cup) {
        
        var cups: [Int:Cup] = [:]
        var currentCup: Cup!
        for valueChar in string.reversed() {
            let value = Int(String(valueChar))!
            currentCup = Cup(value: value, next: currentCup)
            cups[value] = currentCup
        }
        currentCup.makeSequence().last!.next = currentCup
        
        return (cups, currentCup)
    }
    
    private func makeMove(currentCup: Cup) {
        
        // Pick out the cups after the current cup
        let held = currentCup.removeNext(3)
        let heldValues = held.makeSequence().lazy.map { $0.value }
        
        // Find the destination
        var destinationValue = currentCup.value
        repeat {
            destinationValue -= 1
            if destinationValue < 1 { destinationValue = 9 }
        } while heldValues.contains(destinationValue)
        let destination = currentCup.makeSequence().first(where: { $0.value == destinationValue })!
        
        // Insert the removed cups
        destination.insert(held)
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
        func makeSequence() -> UnfoldFirstSequence<Cup> {
            return sequence(first: self) { $0.next }
        }
        
        func insert(_ cup: Cup) {
            let next = self.next
            self.next = cup
            cup.makeSequence().last!.next = next
        }
        
        /// Removes the _k_ next cups in the chain, changing `next` to point to the cup after this amount.
        func removeNext(_ k: Int) -> Cup {
            
            let next = self.next!
            var iterator = self.makeSequence().dropFirst(k).makeIterator()
            
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
