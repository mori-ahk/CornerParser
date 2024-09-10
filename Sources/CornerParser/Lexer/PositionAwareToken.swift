//
//  PositionAwareToken.swift
//
//
//  Created by Mori Ahmadi on 2024-09-08.
//

/// A protocol representing a token that is aware of its position within the source text.
public protocol PositionAwareToken {
    /// The line number where the token is located, starting from 1.
    var line: Int { get }
    
    /// The column number where the token begins on the line, starting from 1.
    var column: Int { get }
    
    /// The actual symbol or string representation of the token.
    var symbol: String { get }
}
