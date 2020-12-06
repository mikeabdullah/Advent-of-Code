//
//  Day6.swift
//  AoCTests
//
//  Created by Mike on 06/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day6: XCTestCase {

    var input: String!

    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-6", withExtension: "txt")!
        self.input = try String(contentsOf: location)
    }

    
    func testPart1() {
        let groups = input.split(separator: "\n\n")
        
        print(groups)
    }
}


extension String {
    
    /// Split around a series of elements.
    func split<S>(separator: S) -> [SubSequence] where S : StringProtocol {
        
        var chunks = [SubSequence]()
        var chunk = self[startIndex..<endIndex]
        
        while let range = chunk.range(of: separator) {
            chunks.append(chunk.prefix(upTo: range.lowerBound))
            chunk = self.suffix(from: range.upperBound)
        }

        chunks.append(chunk)
        
        return chunks
    }
}
