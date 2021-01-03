//
//  Day25.swift
//  AoCTests
//
//  Created by Mike on 03/01/2021.
//  Copyright © 2021 Mike Abdullah. All rights reserved.
//

import XCTest

class Day25: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoopSize8() throws {
        XCTAssertEqual(key(subjectNumber: 7, loopSize: 8), 5764801)
    }
    
    func testLoopSize11() {
        XCTAssertEqual(key(subjectNumber: 7, loopSize: 11), 17807724)
    }
    
    func testKey5764801() {
        XCTAssertEqual(loopSize(key: 5764801, subjectNumber: 7), 8)
    }
    
    func testKey17807724() {
        XCTAssertEqual(loopSize(key: 17807724, subjectNumber: 7), 11)
    }
    
    func testEncryptionKeyViaDoor() {
        XCTAssertEqual(key(subjectNumber: 17807724, loopSize: 8), 14897079)
    }
    
    func testEncryptionKeyViaCard() {
        XCTAssertEqual(key(subjectNumber: 5764801, loopSize: 11), 14897079)
    }
    
    /// Creates a sequence that transforms a subject number infinitely.
    func keySequence(subjectNumber: Int) -> UnfoldSequence<Int, Int> {
        
        return sequence(state: 1) { value -> Int? in
            value *= subjectNumber
            value %= 20201227
            return value
        }
    }
    
    /// Calculates the key for a given subject number and loop size
    func key(subjectNumber: Int, loopSize: Int) -> Int {
        keySequence(subjectNumber: subjectNumber).prefix(loopSize).last!
    }
    
    /// Finds the loop size that gives `key`, for given subject number.
    func loopSize(key: Int, subjectNumber: Int) -> Int {
        let (offset, _) = keySequence(subjectNumber: subjectNumber).enumerated().first { pair -> Bool in
            return pair.element == key
        }!
        
        return offset + 1
    }
}
