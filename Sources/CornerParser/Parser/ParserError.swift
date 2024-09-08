//
//  ParserError.swift
//
//
//  Created by Mori Ahmadi on 2024-08-03.
//

import Foundation

public enum ParseError: Error, CustomStringConvertible {
    case unexpectedToken(expected: String, found: any PositionAwareToken)
    case expectedIdentifier
    
    public var description: String {
        switch self {
        case let .unexpectedToken(expected, found):
            return "Unexpected token at line: \(found.line). Expected \(expected), found \(found.symbol)"
        case .expectedIdentifier:
            return "Expected identifier"
        }
    }
}

extension ParseError: Equatable {
    public static func == (lhs: ParseError, rhs: ParseError) -> Bool {
        switch (lhs, rhs) {
        case let (.unexpectedToken(expected1, found1), .unexpectedToken(expected2, found2)):
            return expected1 == expected2
            && found1.line == found2.line
            && found1.column == found2.column
            && found1.column == found2.column
        case (.expectedIdentifier, .expectedIdentifier):
            return true
        default:
            return false
        }
    }
}
