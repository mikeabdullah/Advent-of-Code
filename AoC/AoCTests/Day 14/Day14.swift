//
//  Day14.swift
//  AoCTests
//
//  Created by Mike on 14/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day14: XCTestCase {

    var input: [Substring]!
    
    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-14", withExtension: "txt")!
        let input = try String(contentsOf: location)
        self.input = input.lines
    }

    func testPart1() throws {
        var machine = Machine()
        machine.execute(input)
        
        XCTAssertEqual(machine.memory.values.sum, 12512013221615)
    }

    
    
    
    struct Machine {
        
        /// Values by address.
        var memory: [Int: Int] = [:]
        
        mutating func execute(_ program: [Substring]) {
            
            var mask0 = 0
            var mask1 = 0
            
            for line in program {
                let bits = line.components(separatedBy: " = ")
                let assignee = bits[0]
                let value = bits[1]
                
                if assignee == "mask" {
                    mask1 = Int(value.replacingOccurrences(of: "X", with: "0"), radix: 2)!
                    mask0 = Int(value.replacingOccurrences(of: "X", with: "1"), radix: 2)!
                }
                else {
                    let scanner = Scanner(string: assignee)
                    _ = scanner.scanString("mem[")
                    let address = scanner.scanInt()!
                    
                    let value = Int(value)!
                    let masked = (value | mask1) & mask0
                    memory[address] = masked
                }
            }
        }
    }
}
