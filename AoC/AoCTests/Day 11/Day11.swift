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
            
            var seats = plane.seats
            
            while !seats.isEmpty {
                
                // Mark all seats with few enough neighbors as occupied
                let toOccupy = seats.filter { seat in
                    plane.statesAdjacent(to: seat).count(where: { $0 == .undecided }) < 4
                }
                
                for seat in toOccupy {
                    plane[seat] = .occupied
                }
                seats.subtract(toOccupy)
                
                // Mark all remaining seats with an occupied neighbor as being permanently empty
                let toEmpty = seats.filter { seat in
                    plane.statesAdjacent(to: seat).contains(.occupied)
                }
                for seat in toEmpty {
                    plane[seat] = .empty
                }
                seats.subtract(toEmpty)
            }
            
            let occupied = plane.occupationCount
            XCTAssertEqual(occupied, 2344)
        }
    }
    
    typealias Coordinate = SIMD2<Int>
    
    struct Plane : Hashable {
        
        enum SeatState : Hashable {
            case occupied
            case empty
            case undecided
            
            var isOccupied: Bool {
                switch self {
                case .occupied: return true
                case .empty, .undecided: return false
                }
            }
        }
        
        private var storage: [Coordinate: SeatState] = [:]
        
        init() { }
        
        init(_ rows: [Substring]) {
            
            for (y, seats) in rows.enumerated() {
                for (x, value) in seats.enumerated() {
                    switch value {
                    case "L":
                        // Start uknown
                        storage[[x, y]] = .undecided
                    case ".":
                        break   // floor, ignore
                    default:
                        assertionFailure("Unexpected start state")
                    }
                }
            }
        }
        
        subscript(x: Int, y: Int) -> SeatState? {
            get {
                return storage[[x, y]] ?? nil
            }
            set {
                storage[[x, y]] = newValue
            }
        }
        
        subscript(coordinate: Coordinate) -> SeatState? {
            get {
                return storage[coordinate]
            }
            set {
                storage[coordinate] = newValue
            }
        }
        
        /// Coordinates of all seats in the plane.
        var seats: Set<Coordinate> {
            return Set(storage.keys)
        }
        
        var numberOfSeats: Int {
            return storage.count
        }
        
        func statesAdjacent(to seat: Coordinate) -> [SeatState?] {
            let x = seat.x, y = seat.y
            return [self[x-1, y-1],
                    self[x, y-1],
                    self[x+1, y-1],
                    self[x-1, y],
                    self[x+1, y],
                    self[x-1, y+1],
                    self[x, y+1],
                    self[x+1, y+1]]
        }
        
        func numberOfAdjacentUndecidedSeats(to seat: Coordinate) -> Int {
            return statesAdjacent(to: seat)
                .count(where: { $0 == .undecided })
        }
        
        var occupationCount: Int {
            return storage.values.count(where: { $0 == .occupied })
        }
    }
}
