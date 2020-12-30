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
            let plane = Plane(input)
            
            var undecided = plane.seats
            var occupiedSeats: Set<Coordinate> = []
                    
            while !undecided.isEmpty {
                
                // Mark all seats with few enough neighbors as occupied
                let toOccupy = undecided.filter { seat in
                    plane.coordinatesAdjacent(to: seat).contains(lessThan: 4, where: undecided.contains)
                }
                
                occupiedSeats.formUnion(toOccupy)
                undecided.subtract(toOccupy)
                
                // Mark all remaining seats with an occupied neighbor as being permanently empty
                let toEmpty = undecided.filter { seat in
                    plane.coordinatesAdjacent(to: seat).contains(where: occupiedSeats.contains)
                }
                undecided.subtract(toEmpty)
            }
            
            XCTAssertEqual(occupiedSeats.count, 2344)
        }
    }
    
    func testPart2() {
        measure {
            let plane = Plane(input)
            
            var undecided = plane.seats
            var occupiedSeats: Set<Coordinate> = []
            
            while !undecided.isEmpty {
                
                // Mark all seats with few enough visible seats as occupied
                let toOccupy = undecided.filter { seat in
                    plane.seatsVisible(from: seat).contains(lessThan: 5, where: undecided.contains)
                }
                
                occupiedSeats.formUnion(toOccupy)
                undecided.subtract(toOccupy)
                
                // Mark all remaining seats with an occupied neighbor as being permanently empty
                let toEmpty = undecided.filter { seat in
                    plane.seatsVisible(from: seat).contains(where: occupiedSeats.contains)
                }
                undecided.subtract(toEmpty)
            }
            
            XCTAssertEqual(occupiedSeats.count, 2076)
        }
    }
    
    typealias Coordinate = SIMD2<Int>
    
    class Plane {
        
        /// Coordinates of all seats in the aircraft.
        let seats: Set<Coordinate>
        
        func isSeat(at coordinate: Coordinate) -> Bool {
            return seats.contains(coordinate)
        }
        
        let rowCount: Int, columnCount: Int
        
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
            self.rowCount = rows.count
            self.columnCount = rows.first!.count
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
        
        func seatsVisible(from seat: Coordinate) -> [Coordinate] {
            
            // Use the cache if possible
            if let visible = seatsVisibleFromSeat[seat] {
                return visible
            }
            
            let all = [coordinates(inDirection: [-1, -1], from: seat).dropFirst(),
                       coordinates(inDirection: [+0, -1], from: seat).dropFirst(),
                       coordinates(inDirection: [+1, -1], from: seat).dropFirst(),
                       coordinates(inDirection: [-1, +0], from: seat).dropFirst(),
                       coordinates(inDirection: [+1, +0], from: seat).dropFirst(),
                       coordinates(inDirection: [-1, +1], from: seat).dropFirst(),
                       coordinates(inDirection: [+0, +1], from: seat).dropFirst(),
                       coordinates(inDirection: [+1, +1], from: seat).dropFirst()
            ]
            let visible = all.compactMap { $0.first(where: seats.contains) }
            seatsVisibleFromSeat[seat] = visible
            return visible
        }
        
        private var seatsVisibleFromSeat: [Coordinate: [Coordinate]] = [:]
        
        /// Returns all coordinates in given direction from seat, including the seat itself, infinitely.
        func coordinates(inDirection direction: SIMD2<Int>, from seat: Coordinate) -> UnfoldFirstSequence<Coordinate> {
            sequence(first: seat) { seat in
                let next = seat &+ direction
                guard next.x >= 0, next.y >= 0, next.x < self.columnCount, next.y < self.rowCount
                    else { return nil }
                return next
            }
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
