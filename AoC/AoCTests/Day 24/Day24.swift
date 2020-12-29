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
        
        let floor = Floor(paths: input)
        XCTAssertEqual(floor.blackTiles.count, 254)
    }
    
    func testPart2() {
        
        var floor = Floor(paths: input)
        for _ in 1...100 {
            floor.flipTiles()
        }
        XCTAssertEqual(floor.blackTiles.count, 5548)
    }
}


extension Day24 {
    
    struct Floor {
        
        init(paths: [Substring]) {
            for path in paths {
                let coordinate = self.coordinate(at: path)
                
                // Toggle membership within the set
                if blackTiles.remove(coordinate) == nil {
                    blackTiles.insert(coordinate)
                }
            }
        }
        
        // MARK: Basic Access
        
        var blackTiles: Set<Coordinate> = []
        
        /// Helper to test if a tile is black.
        func isBlack(at coordinate: Coordinate) -> Bool {
            return blackTiles.contains(coordinate)
        }
        
        /// Helper to test if a tile is black.
        func isWhite(at coordinate: Coordinate) -> Bool {
            return !isBlack(at: coordinate)
        }
        
        // MARK: Advanced Queries
        
        /// Derives from the black tile list all white tiles with at least one adjacent black tile.
        var whiteTilesWithAdjacentBlack: Set<Coordinate> {
            
            return blackTiles.reduce(into: []) { (whites, black) in
                let adjacent = self.neighbors(ofTileAt: black)
                whites.formUnion(adjacent.lazy.filter { self.isWhite(at: $0) })
            }
        }
        
        // MARK: Part 2
        
        mutating func flipTiles() {
            
            // Any black tile with zero or more than 2 black tiles immediately adjacent to it is flipped to white
            let blackToWhite = blackTiles.filter { coordinate in
                neighbors(ofTileAt: coordinate)
                    .contains(0, orMoreThan: 2, where: { isBlack(at: $0) })
            }
            
            // Any white tile with exactly 2 black tiles immediately adjacent to it is flipped to black
            let whiteToBlack = whiteTilesWithAdjacentBlack.filter { coordinate in
                assert(isWhite(at: coordinate))
                let adjacent = self.neighbors(ofTileAt: coordinate)
                let adjacentBlacks = adjacent.count(where: { blackTiles.contains($0) })
                return adjacentBlacks == 2
            }
            
            assert(blackToWhite.intersection(whiteToBlack).isEmpty)
            blackTiles.subtract(blackToWhite)
            blackTiles.formUnion(whiteToBlack)
        }
        
        // MARK: Coordinates
        
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
        
        /// The six neighbours of a given tile.
        func neighbors(ofTileAt coordinate: Coordinate) -> [Coordinate] {
            
            let e = coordinate &+ [1, 0]
            let se = coordinate &+ [1, -1]
            let sw = coordinate &+ [-1, -1]
            let w = coordinate &+ [-1, 0]
            let nw = coordinate &+ [-1, 1]
            let ne = coordinate &+ [1, 1]
            return [e, se, sw, w, nw, ne]
        }
    }
}


extension Sequence {
    
    func contains(_ exact: Int, orMoreThan atLeast: Int, where predicate: (Element) -> Bool) -> Bool {
        
        var count = 0
        for element in self where predicate(element) {
            count += 1
            if count > atLeast { return true }
        }
        
        return count == exact
    }
}
