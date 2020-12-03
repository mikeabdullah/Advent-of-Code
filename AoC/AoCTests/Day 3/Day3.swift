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

    func testPart1() throws {
        measure {
            let vector: SIMD2<Int> = [3,1]
            
            let strideX = stride(from: 0, to: .max, by: vector.x)
            let strideY = stride(from: forest.rows.startIndex, to: forest.rows.endIndex, by: vector.y)
            
            let count = zip(strideX, strideY).count(where: { x, y in
                forest.isTreeAt(x: x, y: y)
            })
            
            XCTAssertEqual(count, 181)
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
}
