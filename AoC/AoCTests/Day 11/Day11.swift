//
//  Day11.swift
//  AoCTests
//
//  Created by Mike on 11/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day11: XCTestCase {

    var input: [Substring]!
    
    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-11", withExtension: "txt")!
        let input = try String(contentsOf: location)
        self.input = input.lines
    }

    func testPart1() {
        measure {
            var state = Plane(input)
            
            let evolution = sequence(first: state) { prior in
                return self.applyRules(to: prior)
            }
            
            for next in evolution.dropFirst() {
                if next == state { break }
                state = next
            }
            
            let occupied = state.occupationCount
            XCTAssertEqual(occupied, 2344)
        }
    }
    
    func applyRules(to plane: Plane) -> Plane {
        
        return plane.evolve { coordinate, occupied in
            let x = coordinate.x, y = coordinate.y
            
            if occupied {
                // If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
                let sum = [plane[x-1, y-1],
                           plane[x, y-1],
                           plane[x+1, y-1],
                           plane[x-1, y],
                           plane[x+1, y],
                           plane[x-1, y+1],
                           plane[x, y+1],
                           plane[x+1, y+1]]
                    .count(where: { $0 })
                
                return sum < 4
            }
            else {
                // If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
                return !plane[x-1, y-1] &&
                    !plane[x, y-1] &&
                    !plane[x+1, y-1] &&
                    !plane[x-1, y] &&
                    !plane[x+1, y] &&
                    !plane[x-1, y+1] &&
                    !plane[x, y+1] &&
                    !plane[x+1, y+1]
            }
        }
    }
    
    typealias Coordinate = SIMD2<Int>
    
    struct Plane : Hashable {
        
        private var storage: [Coordinate: Bool] = [:]
        
        init() { }
        
        init(_ rows: [Substring]) {
            
            for (y, seats) in rows.enumerated() {
                for (x, value) in seats.enumerated() {
                    switch value {
                    case "L":
                        // Empty, but we know all empty seats become full
                        storage[[x, y]] = true
                    case ".":
                        break   // floor, ignore
                    default:
                        assertionFailure("Unexpected start state")
                    }
                }
            }
        }
        
        subscript(x: Int, y: Int) -> Bool {
            get {
                return storage[[x, y]] ?? false
            }
            set {
                storage[[x, y]] = newValue
            }
        }
        
//        subscript(x: Int, y: Int) -> Int {
//            return self[x, y] ? 1 : 0
//        }
        
        var occupationCount: Int {
            return storage.values.count(where: { $0 })
        }
        
        func evolve(_ transform: (Coordinate, Bool) -> Bool) -> Plane {
            
            var plane = Plane()
            plane.storage.reserveCapacity(self.storage.capacity)
            
            for (coordinate, occupied) in storage {
                plane.storage[coordinate] = transform(coordinate, occupied)
            }
            
            return plane
        }
    }
}
