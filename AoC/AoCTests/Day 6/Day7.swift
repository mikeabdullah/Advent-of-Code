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

    func testPart2() throws {
        measure {
            let list = RuleList(lines: input)
            
            let rule = list.rule(for: "shiny gold")!
            let total = list.totalBagsRequired(inside: rule)
            XCTAssertEqual(total, 41559)
        }
    }
    
    struct Rule : Hashable {
        
        let containerColor: Substring
        /// A color of bag, and how many of it should be contained.
        let contains: [WeightedEdge<String>]
        
        init(string: Substring) {
            
            let split = string.range(of: " bags contain ")!
            self.containerColor = string.prefix(upTo: split.lowerBound)
            
            let contents = string.suffix(from: split.upperBound).dropLast()
            if contents == "no other bags" {
                self.contains = []
                return
            }
            
            let components = contents.components(separatedBy: ", ")
            self.contains = components.map { string in
                let scanner = Scanner(string: string)
                let count = scanner.scanInt()!
                _ = scanner.scanString(" ")
                let color = scanner.scanUpToString(" bag")!
                return WeightedEdge(vertex: color, weight: count)
            }
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
        
        func rule<S>(for color: S) -> Rule? where S : StringProtocol {
            return rules.first(where: { $0.containerColor == color })
        }
        
        func rules<S>(containing color: S) -> [Rule] where S : StringProtocol {
            return rules.filter { rule in
                rule.contains.contains(where: { $0.vertex == color })
            }
        }
        
        func totalBagsRequired(inside rule: Rule) -> Int {
            
            return rule.contains.reduce(0) { sum, contained in
                let subrule = self.rule(for: contained.vertex)!
                return sum + contained.weight * (1 + self.totalBagsRequired(inside: subrule))
            }
        }
    }
}


/// A weighted edge in a Directed Acyclic Graph.
struct WeightedEdge<Vertex> : Hashable where Vertex : Hashable {
    let vertex: Vertex
    let weight: Int
}
