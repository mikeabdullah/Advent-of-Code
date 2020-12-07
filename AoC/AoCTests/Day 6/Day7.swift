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
        let contentRules: [ContainedBagRule]
        
        init(string: Substring) {
            
            let split = string.range(of: " bags contain ")!
            self.containerColor = string.prefix(upTo: split.lowerBound)
            
            let contents = string.suffix(from: split.upperBound).dropLast()
            if contents == "no other bags" {
                self.contentRules = []
                return
            }
            
            let components = contents.components(separatedBy: ", ")
            self.contentRules = components.map { ContainedBagRule(string: $0) }
        }
    }
    
    struct ContainedBagRule : Hashable {
        /// A color of bag.
        let color: String
        /// How many of this color of bag there must be.
        let count: Int
        
        init(string: String) {
            
            let scanner = Scanner(string: string)
            self.count = scanner.scanInt()!
            _ = scanner.scanString(" ")
            self.color = scanner.scanUpToString(" bag")!
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
                rule.contentRules.contains(where: { $0.color == color })
            }
        }
    }
}
