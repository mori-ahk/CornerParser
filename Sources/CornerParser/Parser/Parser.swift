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
    
    /// Parses a sequence of tokens to generate an Abstract Syntax Tree (AST) representation.
    ///
    /// This method iterates through the tokens in the input, processing each one according to its type. The `parse()` method
    /// expects a specific token type (`.node`) at each step, and will throw an error if an unexpected token is encountered.
    /// Once all tokens are parsed, it returns a root `ASTNode` of type `.diagram`, containing all the parsed nodes as children.
    ///
    /// - Throws: `ParseError.unexpectedToken` when a wrong token other than is encountered during parsing. The error provides
    ///      the expected token and the actual token that was found.
    ///
    /// - Returns:
    ///    An `ASTNode` representing the root of the diagram. The root node has an array of child nodes representing
    ///    the parsed elements.
    ///
    /// # Example
    /// ```swift
    /// let parser = Parser(lexer: Lexer(input: input))
    /// let ast = try parser.parse()
    /// print(ast) // ASTNode.diagram with parsed children nodes
    /// ```
    ///
    /// # Discussion
    /// This method forms the core of the parsing process by building up the tree structure of the diagram. It continually adds
    /// ``ASTNode`` elements to the tree until it reaches the end of the token stream. The parsing process is essential for
    /// transforming a tokenized input into a structure that can later be rendered or interpreted.
    ///
    /// - Important:
    ///    The function assumes that `.eof` (end-of-file) tokens signal the end of the input. Therefore, all valid token streams
    ///    must be terminated by an `.eof` token, or parsing will fail.
    ///
    /// - See Also:
    ///   - ``ASTNode``: The structure used to represent nodes in the abstract syntax tree.
    ///   
    func parse() throws -> ASTNode {
        var elements: [ASTNode] = []
        while currentToken.token != .eof {
            switch currentToken.token {
            case .node:
                elements.append(.node(try parseNode()))
            default:
                throw ParseError.unexpectedToken(expected: Token.node.symbol, found: currentToken)
            }
        }
        
        return .diagram(children: elements)
    }
    
    private func advance() {
        currentToken = lexer.nextToken()
    }
    
    private func expect(_ expectedToken: Token) throws {
        if currentToken.token == expectedToken {
            advance()
        } else {
            throw ParseError.unexpectedToken(expected: expectedToken.symbol, found: currentToken)
        }
    }
    
    private func parseNode() throws -> ASTNode.NodeDecl {
        var attribute: ASTNode.NodeAttribute?
        var edges: [ASTNode.EdgeDecl] = []
        try expect(.node)
        guard case let .identifier(id) = currentToken.token else {
            throw ParseError.expectedIdentifier
        }
        
        advance()
        try expect(.lbrace)
        
        while currentToken.token != .rbrace {
            switch currentToken.token {
            case .color:
                attribute = try parseColorAttribute()
            case .calls:
                edges.append(try parseEdge(for: id))
            default:
                throw ParseError.unexpectedToken(expected: Token.rbrace.symbol, found: currentToken)
            }
        }
        
        try expect(.rbrace)
        return ASTNode.NodeDecl(id: id, attribute: attribute, edges: edges)
    }
    
    private func parseEdge(for nodeId: String) throws -> ASTNode.EdgeDecl {
        var attributes: [ASTNode.EdgeAttribute] = []
        try expect(.calls)
        
        guard case let .identifier(to) = currentToken.token else {
            throw ParseError.expectedIdentifier
        }
        
        advance()
        
        try expect(.lbrace)
       
        while currentToken.token != .rbrace {
            switch currentToken.token {
            case .label:
                attributes.append(try parseLabelAttribute())
            default:
                throw ParseError.unexpectedToken(expected: Token.rbrace.symbol, found: currentToken)
            }
        }
        
        try expect(.rbrace)
        return ASTNode.EdgeDecl(from: nodeId, to: to, attributes: attributes)
    }
    
    private func parseColorAttribute() throws -> ASTNode.NodeAttribute {
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
        
        guard case let .identifier(label) = currentToken.token else {
            throw ParseError.expectedIdentifier
        }
        
        advance()
        return .label(label)
    }
}

