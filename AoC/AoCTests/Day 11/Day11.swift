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
            var plane = Plane(input)
            
            var undecided = plane.seats
            
            while !undecided.isEmpty {
                
                // Mark all seats with few enough neighbors as occupied
                let toOccupy = undecided.filter { seat in
                    plane.coordinatesAdjacent(to: seat).contains(lessThan: 4, where: undecided.contains)
                }
                
                plane.occupiedSeats.formUnion(toOccupy)
                undecided.subtract(toOccupy)
                
                // Mark all remaining seats with an occupied neighbor as being permanently empty
                let toEmpty = undecided.filter { seat in
                    plane.coordinatesAdjacent(to: seat).contains(where: plane.occupiedSeats.contains)
                }
                undecided.subtract(toEmpty)
            }
            
            let occupied = plane.occupiedSeats.count
            XCTAssertEqual(occupied, 2344)
        }
    }
    
    typealias Coordinate = SIMD2<Int>
    
    struct Plane : Hashable {
        
        /// Coordinates of all seats in the aircraft.
        let seats: Set<Coordinate>
        
        func isSeat(at coordinate: Coordinate) -> Bool {
            return seats.contains(coordinate)
        }
        
        var occupiedSeats: Set<Coordinate> = []
                
        init(_ rows: [Substring]) {
            
            var seats: Set<Coordinate> = []
            
            for (y, columns) in rows.enumerated() {
                for (x, value) in columns.enumerated() {
                    switch value {
                    case "L":
                        // Start uknown
                        seats.insert([x, y])
                    case ".":
                        break   // floor, ignore
                    default:
                        assertionFailure("Unexpected start state")
                    }
                }
            }
            
            self.seats = seats
        }
        
        /// Finds all possible _coordinates_ next to a location.
        func coordinatesAdjacent(to seat: Coordinate) -> [Coordinate] {
            return [seat &+ [-1, -1],
                    seat &+ [0, -1],
                    seat &+ [+1, -1],
                    seat &+ [-1, 0],
                    seat &+ [+1, 0],
                    seat &+ [-1, +1],
                    seat &+ [0, +1],
                    seat &+ [+1, +1]]
        }
        
        /// Filters possible adjacent coordinates down to just those which are seats.
        func seatsAdjacent(to seat: Coordinate) -> [Coordinate] {
            return coordinatesAdjacent(to: seat).filter(isSeat)
        }
    }
}


extension Sequence {
    
    func contains(lessThan max: Int, where predicate: (Element) -> Bool) -> Bool {
        
        var count = 0
        for element in self where predicate(element) {
            count += 1
            guard count < max else { return false }
        }
        return true
    }
}
