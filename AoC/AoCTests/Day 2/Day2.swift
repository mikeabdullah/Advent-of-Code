//
//  Day2.swift
//  AoCTests
//
//  Created by Mike on 02/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day2: XCTestCase {

    func testPart1() throws {
        let location = Bundle(for: Day2.self).url(forResource: "input-2", withExtension: "txt")!
        let input = try String(contentsOf: location)
        let lines = input.split(separator: "\n")
        
        let passwordsAndPolicies: [(passwod: Substring, policy: Policy)] = lines.reduce(into: [], { result, line in
            let separation = line.range(of: ": ")!
            let password = line.suffix(from: separation.upperBound)
            let policy = Policy(line.prefix(upTo: separation.lowerBound))
            result.append((password, policy))
        })
        
        measure {
            
            let validPasswords = passwordsAndPolicies.count { password, policy in
                policy.validate(password)
            }

            print(validPasswords)
        }
    }
    
    struct Policy : Hashable {
        /// The letter the policy controls
        let character: Character
        /// The max and min times the letter can appear
        let range: ClosedRange<Int>
        
        init(_ string: Substring) {
            let space = string.range(of: " ")!
            self.character = string[space.upperBound]
            
            let rangeString = string.prefix(upTo: space.lowerBound)
            let separator = rangeString.range(of: "-")!
            let lowerBound = Int(rangeString.prefix(upTo: separator.lowerBound))!
            let upperBound = Int(rangeString.suffix(from: separator.upperBound))!
            self.range = lowerBound...upperBound
        }
        
        func validate(_ password: Substring) -> Bool {
            let occurrences = password.count(of: character)
            return range.contains(occurrences)
        }
    }
}


extension Sequence {
    
    /// Counts how many elements match `predicate`.
    func count(where predicate: (Element) -> Bool) -> Int {
        var result = 0
        for element in self where predicate(element) {
            result += 1
        }
        return result
    }
}

extension Sequence where Element : Comparable {
    
    /// Counts how many times an element appears.
    func count(of element: Element) -> Int {
        return count(where: { $0 == element })
    }
}
