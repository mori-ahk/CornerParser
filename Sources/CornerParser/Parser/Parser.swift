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
            case .edge:
                elements.append(.edge(try parseEdge()))
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
        
        while currentToken != .rbrace {
            switch currentToken {
            case .color:
                try expect(.color)
                try expect(.colon)
                guard case let .identifier(color) = currentToken else {
                    throw ParseError.expectedIdentifier
                }
                attribute = .color(color)
                advance()
                
            case .node:
                children.append(try parseNode())
                
            default:
                throw ParseError.unexpectedToken(expected: .rbrace, actual: currentToken)
            }
        }
        
        try expect(.rbrace)
        return ASTNode.NodeDecl(id: id, attribute: attribute, children: children)
    }
    
    private func parseEdge() throws -> ASTNode.EdgeDecl {
        var attributes: [ASTNode.EdgeAttribute] = []
        try expect(.edge)
        guard case let .identifier(from) = currentToken else {
            throw ParseError.expectedIdentifier
        }
        advance()
        
        try expect(.arrow)
        guard case let .identifier(to) = currentToken else {
            throw ParseError.expectedIdentifier
        }
        advance()
        
        try expect(.lbrace)
       
        while currentToken != .rbrace {
            switch currentToken {
            case .color:
                attributes.append(try parseColorAttribute())
            case .label:
                attributes.append(try parseLabelAttribute())
            default:
                throw ParseError.unexpectedToken(expected: .rbrace, actual: currentToken)
            }
        }
        
        try expect(.rbrace)
        return ASTNode.EdgeDecl(from: from, to: to, attributes: attributes)
    }
    
    
    private func parseColorAttribute() throws -> ASTNode.EdgeAttribute {
        try expect(.color)
        try expect(.colon)
        guard case let .identifier(color) = currentToken else {
            throw ParseError.expectedIdentifier
        }
        advance()
        return .color(color)
    }

    private func parseLabelAttribute() throws -> ASTNode.EdgeAttribute {
        try expect(.label)
        try expect(.colon)
        try expect(.quote)
        guard case let .identifier(label) = currentToken else {
            throw ParseError.expectedIdentifier
        }
        advance()
        try expect(.quote)
        return .label(label)
    }
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
