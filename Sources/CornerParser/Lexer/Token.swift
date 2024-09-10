//
//  Token.swift
//
//
//  Created by Mori Ahmadi on 2024-08-01.
//

import Foundation

enum Token: Equatable {
    case node
    case calls
    case identifier(String)
    case lbrace
    case rbrace
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
    
    var symbol: String {
        switch self {
        case .node: return "'node'"
        case .calls: return "'calls'"
        case .identifier: return "Identifier"
        case .lbrace: return "lbrace '{'"
        case .rbrace: return "rbrace '}'"
        case .colon: return "':'"
        case .color: return "'color'"
        case .label: return "'label'"
        case .quote: return "\""
        default: return ""
        }
    }
}
