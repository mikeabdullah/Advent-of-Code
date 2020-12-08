//
//  Day8.swift
//  AoCTests
//
//  Created by Mike on 08/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day8: XCTestCase {

    var input: [Substring]!
    
    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-8", withExtension: "txt")!
        let input = try String(contentsOf: location)
        self.input = input.lines
    }

    func testPart1() throws {
        
        var loader = BootLoad()
        loader.runUntilRepeat(input)
        XCTAssertEqual(loader.accumulator, 1521)
    }
    

    func testPart2() throws {
        
        let program = input.map { String($0) }
        
        for i in program.indices.reversed() {
            
            var line = program[i]
            var modifiedProgram = program
            
            if let range = line.range(of: "nop", options: .anchored) {
                line.replaceSubrange(range, with: "jmp")
                modifiedProgram[i] = line
            }
            else if let range = line.range(of: "jmp", options: .anchored) {
                line.replaceSubrange(range, with: "nop")
                modifiedProgram[i] = line
            }
            else {
                continue
            }
            
            // Try running this version of the program
            var loader = BootLoad()
            if loader.runUntilRepeat(modifiedProgram) {
                XCTAssertEqual(loader.accumulator, 1016)
            }
        }
    }
    
    struct BootLoad {
        
        var accumulator = 0
        
        /// Runs a progam, starting at the first line.
        /// - Returns: Whether execution finished successfully from reaching the end of the file,
        ///   or failed from repeating.
        @discardableResult
        mutating func runUntilRepeat<S>(_ program: [S]) -> Bool where S : StringProtocol {
            
            var executedLines = IndexSet()
            var line = 0
            
            while !executedLines.contains(line) {
                
                if line == program.endIndex {
                    return true
                }
                
                executedLines.insert(line)
                line += executeLine(program[line])
            }
            
            return false
        }
                
        /// Interprets an instruction, adjusting `accumulator` as needed. Returns how much to offset by to reach the next instruction.
        mutating func executeLine<S>(_ line: S) -> Int where S : StringProtocol {
            
            let scanner = Scanner(string: String(line))
            let instruction = scanner.scanUpToString(" ")!
            let argument = scanner.scanInt()!
            
            switch instruction {
            case "acc":
                accumulator += argument
                return 1
            case "jmp":
                return argument
            case "nop":
                return 1
            default:
                assertionFailure("unknown instruction")
                return 1
            }
        }
    }
}
