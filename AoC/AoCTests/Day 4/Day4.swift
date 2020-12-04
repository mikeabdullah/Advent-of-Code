//
//  Day4.swift
//  AoCTests
//
//  Created by Mike on 04/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day4: XCTestCase {
    
    var data: [PassportData]!

    override func setUpWithError() throws {
        let location = Bundle(for: Day2.self).url(forResource: "input-4", withExtension: "txt")!
        var input = try String(contentsOf: location)
        input = input.replacingOccurrences(of: "\n\n", with: "§")
        input = input.replacingOccurrences(of: "\n", with: " ")
        let batches = input.split(separator: "§")
        
        self.data = batches.map { PassportData($0) }
    }

    func testPart1() throws {
        let numberValid = data.count(where: { $0.validate() })
        XCTAssertEqual(numberValid, 219)
    }

    struct PassportData {
        init(_ string: Substring) {
            
            let regex = try! NSRegularExpression(pattern: #"(.+):(.+)"#, options: [])
            
            // Tear into fields
            var fields: [Substring: Substring] = [:]
            for field in string.split(separator: " ") {
                let string = String(field)
                let match = regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.utf16.count))!
                let key = string[Range(match.range(at: 1), in: string)!]
                let value = string[Range(match.range(at: 2), in: string)!]
                fields[key] = value
            }
            
            self.fields = fields
        }
        
        let fields: [Substring: Substring]
        
        func validate() -> Bool {
            var keys = Set(fields.keys)
            keys.remove("cid")
            
            return keys == ["byr", "iyr", "eyr", "iyr", "hgt", "hcl", "ecl", "pid"]
        }
    }
}
