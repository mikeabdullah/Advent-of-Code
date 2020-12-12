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
        var location: SIMD2<Int> = .zero
        var direction: SIMD2<Int> = [1, 0]
        
        let instructions = input.lazy.map { Instruction($0) }
        
        for instruction in instructions {
            switch instruction.action {
            case "N":
                location &+= [0, 1] &* instruction.value
            case "S":
                location &+= [0, -1] &* instruction.value
            case "E":
                location &+= [1, 0] &* instruction.value
            case "W":
                location &+= [-1, 0] &* instruction.value
                
            case "L":
                let angle = instruction.value
                direction.rotate(clockwise: false, times: angle/90)
            case "R":
                let angle = instruction.value
                direction.rotate(clockwise: true, times: angle/90)
                
            case "F":
                location &+= direction &* instruction.value
                
            default:
                assertionFailure("Unknown action")
            }
        }
        
        let distance = abs(location.x) + abs(location.y)
        XCTAssertEqual(distance, 420)
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
