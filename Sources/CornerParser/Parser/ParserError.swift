//
//  ParserError.swift
//
//
//  Created by Mori Ahmadi on 2024-08-03.
//

import Foundation

enum ParseError: Error, CustomStringConvertible, Equatable {
    case unexpectedToken(expected: Token, found: LexedToken)
    case expectedIdentifier
    
    var description: String {
        switch self {
        case let .unexpectedToken(expected, found):
            return "Unexpected token at line: \(found.position.line). Expected \(expected), found \(found.token)"
        case .expectedIdentifier:
            return "Expected identifier"
        }
    }
}
