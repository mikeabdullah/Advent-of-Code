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
        let numberValid = data.count(where: { $0.validate(fieldValues: false) })
        XCTAssertEqual(numberValid, 219)
    }

    func testPart2() throws {
        let numberValid = data.count(where: { $0.validate(fieldValues: true) })
        XCTAssertEqual(numberValid, 127)
    }

    struct PassportData {
        init(_ string: Substring) {
            
            let regex = try! NSRegularExpression(pattern: #"(.+):(.+)"#)
            
            // Tear into fields
            var fields: [Substring: Substring] = [:]
            for field in string.split(separator: " ") {
                let match = regex.firstMatch(in: field)!
                let key = string[Range(match.range(at: 1), in: string.base)!]
                let value = string[Range(match.range(at: 2), in: string.base)!]
                fields[key] = value
            }
            
            self.fields = fields
        }
        
        let fields: [Substring: Substring]
        
        func validate(fieldValues: Bool) -> Bool {
            if fieldValues {
                return validateBirthYear() && validateIssueYear() && validateExpirationYear() &&
                    validateHeight() &&
                    validateHairColor() && validateEyeColor() &&
                    validatePassportID()
            }
            else {
                var keys = Set(fields.keys)
                keys.remove("cid")
                
                return keys == ["byr", "iyr", "eyr", "iyr", "hgt", "hcl", "ecl", "pid"]
            }
        }
        
        // MARK: Years
        
        static let yearRegex = try! NSRegularExpression(pattern: "[0-9]{4}")
        
        func validateBirthYear() -> Bool {
            guard let value = fields["byr"]
                else { return false }
            
            guard let _ = Self.yearRegex.firstMatch(in: value, options: .anchored)
                else { return false }
            guard let year = Int(value) else { return false }
            return (1920...2002).contains(year)
        }
        
        func validateIssueYear() -> Bool {
            guard let value = fields["iyr"]
                else { return false }
            
            guard let _ = Self.yearRegex.firstMatch(in: value, options: .anchored)
                else { return false }
            guard let year = Int(value) else { return false }
            return (2010...2020).contains(year)
        }
        
        func validateExpirationYear() -> Bool {
            guard let value = fields["eyr"]
                else { return false }
            
            guard let _ = Self.yearRegex.firstMatch(in: value, options: .anchored)
                else { return false }
            guard let year = Int(value) else { return false }
            return (2020...2030).contains(year)
        }
        
        // MARK: Height
        
        func validateHeight() -> Bool {
            guard let value = fields["hgt"]
                else { return false }
            
            if let match = Self.cmRegex.firstMatch(in: value) {
                let substring = value[Range(match.range(at: 1), in: value.base)!]
                guard let value = Int(substring) else { return false }
                return (150...193).contains(value)
            }
            else if let match = Self.inchRegex.firstMatch(in: value) {
                let substring = value[Range(match.range(at: 1), in: value.base)!]
                guard let value = Int(substring) else { return false }
                return (59...76).contains(value)
            }
            else {
                return false
            }
        }
        
        static let cmRegex = try! NSRegularExpression(pattern: #"^([0-9]{3})cm$"#)
        static let inchRegex = try! NSRegularExpression(pattern: #"^([0-9]{2,3})in$"#)
        
        // MARK: Colors
        
        func validateHairColor() -> Bool {
            guard let value = fields["hcl"]
                else { return false }
            
            let match = Self.hairColorRegex.firstMatch(in: value)
            return match != nil
        }
        
        static let hairColorRegex = try! NSRegularExpression(pattern: "^#[0-9a-f]{6}$")
        
        func validateEyeColor() -> Bool {
            guard let value = fields["ecl"]
                else { return false }
            
            return Set(["amb","blu", "brn", "gry", "grn", "hzl", "oth"]).contains(String(value))
        }
        
        // MARK: Passport
        
        func validatePassportID() -> Bool {
            guard let value = fields["pid"]
                else { return false }
            
            let match = Self.idRegex.firstMatch(in: value)
            return match != nil
        }
        
        static let idRegex = try! NSRegularExpression(pattern: "^[0-9]{9}$")
    }
}


extension NSRegularExpression {
    
    /// Convenience to search the whole of a string.
    func firstMatch(in string: String, options: MatchingOptions = []) -> NSTextCheckingResult? {
        return firstMatch(in: string,
                          options: options,
                          range: NSRange(string.startIndex..<string.endIndex, in: string))
    }
    
    /// Convenience to search the whole of a sub-string.
    func firstMatch(in substring: Substring, options: MatchingOptions = []) -> NSTextCheckingResult? {
        return firstMatch(in: substring.base,
                          options: options,
                          range: NSRange(substring.startIndex..<substring.endIndex, in: substring.base))
    }
}
