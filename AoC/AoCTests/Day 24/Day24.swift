//
//  Day24.swift
//  AoCTests
//
//  Created by Mike on 28/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day24: XCTestCase {
    
    typealias Coordinate = SIMD2<Int>

    var input: [Substring]!
    
    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-24", withExtension: "txt")!
        let input = try String(contentsOf: location)
        self.input = input.lines
    }

    func testPart1() throws {
        
        var blackTiles = Set<Coordinate>()
        for path in input {
            let coordinate = self.coordinate(at: path)
            
            // Toggle membership within the set
            if blackTiles.remove(coordinate) == nil {
                blackTiles.insert(coordinate)
            }
        }
        
        XCTAssertEqual(blackTiles.count, 254)
    }

    /// Returns the coordinate of a tile relative to the center by following `path`.
    func coordinate<S>(at path: S) -> Coordinate where S : StringProtocol {
        
        var coordinate: Coordinate = [0, 0]
        for direction in path {
            switch direction {
            // North/South directions can always be followed exactly, landing us between two tiles
            case "n":
                coordinate.y += 1
                assert(!isTile(at: coordinate))
            case "s":
                coordinate.y -= 1
                assert(!isTile(at: coordinate))
                
            // When heading east or west walk to the next tile. This depends on whether we start
            // on a tile or a gap
            case "e":
                repeat {
                    coordinate.x += 1
                } while !isTile(at: coordinate)
            case "w":
                repeat {
                    coordinate.x -= 1
                } while !isTile(at: coordinate)
                
            default:
                preconditionFailure("Unsupported direction")
            }
        }
        
        return coordinate
    }
    
    /// Returns whether the coordinate is a tile or the gap between two tiles.
    func isTile(at coordinate: Coordinate) -> Bool {
        // Tiles always have an even total coordinate
        return coordinate.wrappedSum().isMultiple(of: 2)
    }
}
