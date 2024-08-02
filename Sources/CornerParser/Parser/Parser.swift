//
//  Parser.swift
//
//
//  Created by Mori Ahmadi on 2024-08-02.
//

import Foundation

class Parser {
    private let lexer: Lexer
    private var currentToken: Token
    
    init(lexer: Lexer) {
        self.lexer = lexer
        self.currentToken = lexer.nextToken()
    }
    
    private func advance() {
        currentToken = lexer.nextToken()
    }
    
    private func expect(_ expectedToken: Token) throws {
        print("current token: \(currentToken), expected: \(expectedToken)")
        if currentToken == expectedToken {
            advance()
        } else {
            throw ParseError.unexpectedToken(expected: expectedToken, actual: currentToken)
        }
    }
    
    func parse() throws -> ASTNode {
        var elements: [ASTNode] = []
        while currentToken != .eof {
            switch currentToken {
            case .node:
                elements.append(.node(try parseNode()))
//            case .edge:
//                elements.append(.edge(try parseEdge()))
            default:
                throw ParseError.unexpectedToken(expected: .node, actual: currentToken)
            }
        }
        
        return .diagram(children: elements)
    }
    
    private func parseNode() throws -> ASTNode.NodeDecl {
        var attribute: ASTNode.NodeAttribute?
        var children: [ASTNode.NodeDecl] = []
        
        try expect(.node)
        guard case let .identifier(id) = currentToken else {
            throw ParseError.expectedIdentifier
        }
        
        advance()
        try expect(.lbrace)
        
        if currentToken == .color {
            try expect(.color)
            try expect(.colon)
            guard case let .identifier(color) = currentToken else {
                throw ParseError.expectedIdentifier
            }
            
            attribute = .color(color)
            advance()
        }
        
        if currentToken == .node {
            children.append(try parseNode())
        }
        
        try expect(.rbrace)
        return ASTNode.NodeDecl(id: id, attribute: attribute, children: children)
    }
    
//    private func parseEdge() throws -> ASTNode.EdgeDecl {
//        try expect(.edge)
//        guard case let .identifier(id) = currentToken else {
//            throw ParseError.expectedIdentifier
//        }
//        advance()
//        
//        try expect(.identifier)
//        guard case let .identifier(fromId) = currentToken else {
//            throw ParseError.expectedIdentifier
//        }
//        advance()
//        
//        try expect(.to)
//        guard case let .identifier(toId) = currentToken else {
//            throw ParseError.expectedIdentifier
//        }
//        advance()
//        
//        guard case let .label(label) = currentToken else {
//            throw ParseError.expectedLabel
//        }
//        advance()
//        
//        return ASTNode.EdgeDecl(from: fromId, to: toId, label: label)
//    }
}

enum ParseError: Error, CustomStringConvertible {
    case unexpectedToken(expected: Token, actual: Token)
    case expectedIdentifier
    case expectedLabel
    
    var description: String {
        switch self {
        case let .unexpectedToken(expected, actual):
            return "Unexpected token: expected \(expected), got \(actual)"
        case .expectedIdentifier:
            return "Expected identifier"
        case .expectedLabel:
            return "Expected label"
        }
    }
}
