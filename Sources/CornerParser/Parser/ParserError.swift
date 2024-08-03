//
//  ParserError.swift
//
//
//  Created by Mori Ahmadi on 2024-08-03.
//

import Foundation

enum ParseError: Error, CustomStringConvertible, Equatable {
    case unexpectedToken(expected: Token, actual: Token)
    case expectedIdentifier
    
    var description: String {
        switch self {
        case let .unexpectedToken(expected, actual):
            return "Unexpected token: expected \(expected), got \(actual)"
        case .expectedIdentifier:
            return "Expected identifier"
        }
    }
}
