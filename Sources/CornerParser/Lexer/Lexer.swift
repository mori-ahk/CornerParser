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
    private var currentPosition: Token.Position
    
    init(input: String) {
        self.input = input
        self.currentIndex = input.startIndex
        self.currentPosition = .init(line: 1, column: 1)
    }
    
    private func advance() {
        if currentIndex < input.endIndex {
            if input[currentIndex] == "\n" {
                currentPosition.line += 1
                currentPosition.column = 1
            } else {
                currentPosition.column += 1
            }
            currentIndex = input.index(after: currentIndex)
        }
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
    
    func nextToken() -> LexedToken {
        while let currentChar = peek() {
            let tokenPosition = currentPosition
            switch currentChar {
            case "{":
                advance()
                return LexedToken(token: .lbrace, position: tokenPosition)
            case "}":
                advance()
                return LexedToken(token: .rbrace, position: tokenPosition)
            case ":":
                advance()
                return LexedToken(token: .colon, position: tokenPosition)
            case "\"":
                advance()
                return LexedToken(token: .quote, position: tokenPosition)
            case "-":
                advance()
                if let nextChar = peek(), nextChar == ">" {
                    advance()
                    return LexedToken(token: .arrow, position: tokenPosition)
                } else {
                    return LexedToken(token: .unknown("-"), position: tokenPosition)
                }
            case let char where char.isWhitespace:
                _ = consumeWhile { $0.isWhitespace }
            case let char where char.isLetter:
                let identifier = consumeWhile { $0.isLetter || $0.isNumber }
                switch identifier {
                case "node":
                    return LexedToken(token: .node, position: tokenPosition)
                case "edge":
                    return LexedToken(token: .edge, position: tokenPosition)
                case "color":
                    return LexedToken(token: .color, position: tokenPosition)
                case "label":
                    return LexedToken(token: .label, position: tokenPosition)
                default:
                    return LexedToken(token: .identifier(identifier), position: tokenPosition)
                }
            default:
                advance()
                return LexedToken(token: .unknown(String(currentChar)), position: tokenPosition)
            }
        }
        return LexedToken(token: .eof, position: currentPosition)
    }
}
