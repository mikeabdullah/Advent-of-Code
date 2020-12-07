//
//  Day7.swift
//  AoCTests
//
//  Created by Mike on 07/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day7: XCTestCase {
    
    var input: [Substring]!
    
    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-7", withExtension: "txt")!
        let input = try String(contentsOf: location)
        self.input = input.lines
    }

    func testPart1() throws {
        measure {
            let list = RuleList(lines: input)
            
            var batch = Set(list.rules(containing: "shiny gold"))
            var matchingRules = batch
            
            repeat {
                
                let countBefore = matchingRules.count
                
                batch = Set(batch.lazy.flatMap { rule -> [Rule] in
                    let matches = list.rules(containing: rule.containerColor)
                    matchingRules.formUnion(matches)
                    return matches
                })
                
                guard matchingRules.count > countBefore
                    else { break }
                
            } while true
            
            
            XCTAssertEqual(matchingRules.count, 151)
        }
    }

    
    struct Rule : Hashable {
        
        let containerColor: Substring
        let contents: Substring
        
        init(string: Substring) {
            
            let split = string.range(of: " bags contain ")!
            self.containerColor = string.prefix(upTo: split.lowerBound)
            self.contents = string.suffix(from: split.upperBound)
        }
    }
    
    struct RuleList {
        
        init(rules: [Rule]) {
            self.rules = rules
        }
        
        init(lines: [Substring]) {
            self.init(rules: lines.map { Rule(string: $0) })
        }
        
        let rules: [Rule]
        
        func rules<S>(containing color: S) -> [Rule] where S : StringProtocol {
            return rules.filter { rule in
                rule.contents.range(of: color + " bag") != nil
            }
        }
    }
}
