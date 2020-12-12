//
//  Day12.swift
//  AoCTests
//
//  Created by Mike on 12/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day12: XCTestCase {

    var input: [Substring]!
    
    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-12", withExtension: "txt")!
        let input = try String(contentsOf: location)
        self.input = input.lines
    }

    func testPart1() throws {
        let state: (location: SIMD2<Int>, direction: SIMD2<Int>) = (.zero, [1, 0])
        
        let instructions = input.lazy.map { Instruction($0) }
        
        let finalState = instructions.reduce(into: state) { (state, instruction) in
            let value = instruction.value
            
            switch instruction.action {
            case "N":
                state.location.y += value
            case "S":
                state.location.y -= value
            case "E":
                state.location.x += value
            case "W":
                state.location.x -= value
                
            case "L":
                state.direction.rotate(clockwise: false, times: value/90)
            case "R":
                state.direction.rotate(clockwise: true, times: value/90)
                
            case "F":
                state.location &+= state.direction &* value
                
            default:
                assertionFailure("Unknown action")
            }
        }
        
        let distance = abs(finalState.location.x) + abs(finalState.location.y)
        XCTAssertEqual(distance, 420)
    }

    func testPart2() throws {
        let state: (location: SIMD2<Int>, waypoint: SIMD2<Int>) = (.zero, [10, 1])
        
        let instructions = input.lazy.map { Instruction($0) }
        
        let finalState = instructions.reduce(into: state) { (state, instruction) in
            let value = instruction.value
            
            switch instruction.action {
            case "N":
                state.waypoint.y += value
            case "S":
                state.waypoint.y -= value
            case "E":
                state.waypoint.x += value
            case "W":
                state.waypoint.x -= value
                
            case "L":
                state.waypoint.rotate(clockwise: false, times: value/90)
            case "R":
                state.waypoint.rotate(clockwise: true, times: value/90)
                
            case "F":
                state.location &+= state.waypoint &* value
                
            default:
                assertionFailure("Unknown action")
            }
        }
        
        let distance = abs(finalState.location.x) + abs(finalState.location.y)
        XCTAssertEqual(distance, 42073)
    }

    
    struct Instruction {
        let action: Character
        let value: Int
        
        init(_ string: Substring) {
            let string = String(string)
            self.action = string.first!
            
            let scanner = Scanner(string: string)
            scanner.currentIndex = Range(NSMakeRange(1, 0), in: string)!.lowerBound
            self.value = scanner.scanInt()!
        }
    }
}


extension SIMD2 where Scalar == Int {
    
    mutating func rotate(clockwise: Bool, times: Int) {
        
        for _ in 1...times {
            if clockwise {
                self = [self.y, -self.x]
            }
            else {
                self = [-self.y, self.x]
            }
        }
    }
}
