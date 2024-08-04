//
//  Parser.swift
//
//
//  Created by Mori Ahmadi on 2024-08-02.
//

import Foundation

class Parser {
    private let lexer: Lexer
    private var currentToken: LexedToken
    
    init(lexer: Lexer) {
        self.lexer = lexer
        self.currentToken = lexer.nextToken()
    }
    
    private func advance() {
        currentToken = lexer.nextToken()
    }
    
    private func expect(_ expectedToken: Token) throws {
        if currentToken.token == expectedToken {
            advance()
        } else {
            throw ParseError.unexpectedToken(expected: expectedToken, found: currentToken)
        }
    }
    
    func parse() throws -> ASTNode {
        var elements: [ASTNode] = []
        while currentToken.token != .eof {
            switch currentToken.token {
            case .node:
                elements.append(.node(try parseNode()))
            case .edge:
                elements.append(.edge(try parseEdge()))
            default:
                throw ParseError.unexpectedToken(expected: .node, found: currentToken)
            }
        }
        
        return .diagram(children: elements)
    }
    
    private func parseNode() throws -> ASTNode.NodeDecl {
        var attribute: ASTNode.NodeAttribute?
        var children: [ASTNode.NodeDecl] = []
        
        try expect(.node)
        guard case let .identifier(id) = currentToken.token else {
            throw ParseError.expectedIdentifier
        }
        
        advance()
        try expect(.lbrace)
        
        while currentToken.token != .rbrace {
            switch currentToken.token {
            case .color:
                try expect(.color)
                try expect(.colon)
                guard case let .identifier(color) = currentToken.token else {
                    throw ParseError.expectedIdentifier
                }
                attribute = .color(color)
                advance()
                
            case .node:
                children.append(try parseNode())
                
            default:
                throw ParseError.unexpectedToken(expected: .rbrace, found: currentToken)
            }
        }
        
        try expect(.rbrace)
        return ASTNode.NodeDecl(id: id, attribute: attribute, children: children)
    }
    
    private func parseEdge() throws -> ASTNode.EdgeDecl {
        var attributes: [ASTNode.EdgeAttribute] = []
        try expect(.edge)
        guard case let .identifier(from) = currentToken.token else {
            throw ParseError.expectedIdentifier
        }
        advance()
        
        try expect(.arrow)
        guard case let .identifier(to) = currentToken.token else {
            throw ParseError.expectedIdentifier
        }
        advance()
        
        try expect(.lbrace)
       
        while currentToken.token != .rbrace {
            switch currentToken.token {
            case .color:
                attributes.append(try parseColorAttribute())
            case .label:
                attributes.append(try parseLabelAttribute())
            default:
                throw ParseError.unexpectedToken(expected: .rbrace, found: currentToken)
            }
        }
        
        try expect(.rbrace)
        return ASTNode.EdgeDecl(from: from, to: to, attributes: attributes)
    }
    
    
    private func parseColorAttribute() throws -> ASTNode.EdgeAttribute {
        try expect(.color)
        try expect(.colon)
        guard case let .identifier(color) = currentToken.token else {
            throw ParseError.expectedIdentifier
        }
        advance()
        return .color(color)
    }

    private func parseLabelAttribute() throws -> ASTNode.EdgeAttribute {
        try expect(.label)
        try expect(.colon)
        try expect(.quote)
        guard case let .identifier(label) = currentToken.token else {
            throw ParseError.expectedIdentifier
        }
        advance()
        try expect(.quote)
        return .label(label)
    }
}

