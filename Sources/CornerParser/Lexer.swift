//
//  Lexer.swift
//
//
//  Created by Mori Ahmadi on 2024-08-01.
//

import Foundation

class Lexer {
    private let input: String
    private var currentIndex: String.Index
    
    init(input: String) {
        self.input = input
        self.currentIndex = input.startIndex
    }
    
    private func advance() {
        currentIndex = input.index(after: currentIndex)
    }
    
    private func peek() -> Character? {
        guard currentIndex < input.endIndex else { return nil }
        return input[currentIndex]
    }
    
    private func consumeWhile(_ condition: (Character) -> Bool) -> String {
        var result = ""
        while let currentChar = peek(), condition(currentChar) {
            result.append(currentChar)
            advance()
        }
        return result
    }
    
    func nextToken() -> Token {
        while let currentChar = peek() {
            switch currentChar {
            case "{":
                advance()
                return .lbrace
            case "}":
                advance()
                return .rbrace
            case ":":
                advance()
                return .colon
            case "\"":
                advance()
                return .quote
            case "-":
                advance()
                if let nextChar = peek(), nextChar == ">" {
                    advance()
                    return .arrow
                } else {
                    return .unknown("-")
                }
            case let char where char.isWhitespace:
                _ = consumeWhile { $0.isWhitespace }
            case let char where char.isLetter:
                let identifier = consumeWhile { $0.isLetter || $0.isNumber }
                switch identifier {
                case "node":
                    return .node
                case "edge":
                    return .edge
                case "color":
                    return .color
                case "label":
                    return .label
                default:
                    return .identifier(identifier)
                }
            default:
                advance()
                return .unknown(String(currentChar))
            }
        }
        return .eof
    }
}
