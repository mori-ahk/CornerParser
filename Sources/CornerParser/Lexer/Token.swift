//
//  Token.swift
//
//
//  Created by Mori Ahmadi on 2024-08-01.
//

import Foundation

enum Token: Equatable {
    case node
    case edge
    case identifier(String)
    case lbrace
    case rbrace
    case arrow
    case colon
    case color
    case label
    case quote
    case unknown(String)
    case eof
    
    struct Position: Equatable {
        var line: Int
        var column: Int
    }
}
