//
//  Day3.swift
//  AoCTests
//
//  Created by Mike on 03/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day3: XCTestCase {
    
    var forest: Forest!

    override func setUpWithError() throws {
        let location = Bundle(for: Day2.self).url(forResource: "input-3", withExtension: "txt")!
        self.forest = try Forest(contentsOf: location)
    }

    func testPart1() {
        measure {
            let count = forest.numberOfTrees(following: [3,1])
            XCTAssertEqual(count, 181)
        }
    }
        
    func testPart2() {
        let slopes: [SIMD2<Int>] = [
            [1, 1],
            [3, 1],
            [5, 1],
            [7, 1],
            [1, 2]
        ]
        
        measure {
            let counts = slopes.lazy.map { self.forest.numberOfTrees(following: $0) }
            let product = counts.reduce(1, *)
            XCTAssertEqual(product, 1260601650)
        }
    }
}


struct Forest {
    
    init(contentsOf url: URL) throws {
        self.init(try String(contentsOf: url))
    }
    
    init(_ string: String) {
        self.rows = string.lines
        self.rowWidth = rows[0].count
    }
    
    let rows: [Substring]
    let rowWidth: Int
    
    /// Finds the value at given coordinate.
    subscript(x: Int, y: Int) -> Character {
        let x = x % rowWidth    // account for infinite repeat
        let row = rows[y]
        let index = row.index(row.startIndex, offsetBy: x)
        return row[index]
    }
    
    subscript(coordinate: SIMD2<Int>) -> Character {
        return self[coordinate.x, coordinate.y]
    }
    
    func isTreeAt(x: Int, y: Int) -> Bool {
        return self[x, y] == "#"
    }
    
    /// The number of trees encountered if taking `slope`, starting from top left.
    func numberOfTrees(following slope: SIMD2<Int>) -> Int {
        let strideX = stride(from: 0, to: .max, by: slope.x)
        let strideY = stride(from: self.rows.startIndex, to: self.rows.endIndex, by: slope.y)
        
        return zip(strideX, strideY).count(where: { x, y in
            isTreeAt(x: x, y: y)
        })
    }
}
