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

    

}
