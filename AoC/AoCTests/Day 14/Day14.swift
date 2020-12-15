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

    func testPart2() throws {
        var machine = Machine()
        machine.executeV2(input)
        
        XCTAssertEqual(machine.memory.values.sum, 3905642473893)
    }

    func testPart2Sample1() {
        
        let input = """
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
"""
        
        var machine = Machine()
        machine.executeV2(input.lines)
        
        XCTAssertEqual(machine.memory.values.sum, 208)
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
        
        mutating func executeV2(_ program: [Substring]) {
            
            var mask1 = 0
            var floatingMask = [Int]()
            
            for line in program {
                let bits = line.components(separatedBy: " = ")
                let assignee = bits[0]
                let value = bits[1]
                
                if assignee == "mask" {
                    let mask = value
                    
                    mask1 = Int(mask.replacingOccurrences(of: "X", with: "1"), radix: 2)!
                    
                    floatingMask = []
                    for (n, value) in mask.reversed().enumerated() {
                        if value == "X" { floatingMask.append(n) }
                    }
                }
                else {
                    let scanner = Scanner(string: assignee)
                    _ = scanner.scanString("mem[")
                    let baseAddress = scanner.scanInt()!
                    let fixedMaskedAddress = baseAddress | mask1
                    
                    let value = Int(value)!
                    
                    var maxX = 0
                    for _ in floatingMask {
                        maxX = (maxX << 1) + 1
                    }
                    
                    for x in 0...maxX {
                        let address = fixedMaskedAddress.applyingBits(x, of: floatingMask)
                        memory[address] = value
                    }
                }
            }
        }
    }
}

extension Int {
    
    func applyingBits(_ bits: Int, of mask: [Int]) -> Int {
        
        var address = self
        for (n, offset) in mask.enumerated() {
            if (bits & (1 << n)) != 0 {
                address -= 1 << offset
            }
        }
        return address
    }
}
