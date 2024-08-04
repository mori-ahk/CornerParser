//
//  LexerTests.swift
//  
//
//  Created by Mori Ahmadi on 2024-08-02.
//

import XCTest
@testable import CornerParser

final class LexerTests: XCTestCase {
    func testEmptyInput() throws {
        let input = ""
        let lexer = Lexer(input: input)
        XCTAssertEqual(lexer.nextToken().token, .eof)
    }
    
    func testWhitespaceInput() throws {
        let input = "      "
        let lexer = Lexer(input: input)
        XCTAssertEqual(lexer.nextToken().token, .eof)
    }
    
    func testNodeDeclInput() {
        let input = """
        node A {
            color: blue
        }
        """
        let lexer = Lexer(input: input)
        XCTAssertEqual(lexer.nextToken().token, .node)
        XCTAssertEqual(lexer.nextToken().token, .identifier("A"))
        XCTAssertEqual(lexer.nextToken().token, .lbrace)
        XCTAssertEqual(lexer.nextToken().token, .color)
        XCTAssertEqual(lexer.nextToken().token, .colon)
        XCTAssertEqual(lexer.nextToken().token, .identifier("blue"))
        XCTAssertEqual(lexer.nextToken().token, .rbrace)
    }
    
    func testEdgeDeclInput() {
        let input = """
        edge A -> B {
            color: red
            label: "AtoB"
        }
        """
        let lexer = Lexer(input: input)
        XCTAssertEqual(lexer.nextToken().token, .edge)
        XCTAssertEqual(lexer.nextToken().token, .identifier("A"))
        XCTAssertEqual(lexer.nextToken().token, .arrow)
        XCTAssertEqual(lexer.nextToken().token, .identifier("B"))
        XCTAssertEqual(lexer.nextToken().token, .lbrace)
        XCTAssertEqual(lexer.nextToken().token, .color)
        XCTAssertEqual(lexer.nextToken().token, .colon)
        XCTAssertEqual(lexer.nextToken().token, .identifier("red"))
        XCTAssertEqual(lexer.nextToken().token, .label)
        XCTAssertEqual(lexer.nextToken().token, .colon)
        XCTAssertEqual(lexer.nextToken().token, .quote)
        XCTAssertEqual(lexer.nextToken().token, .identifier("AtoB"))
        XCTAssertEqual(lexer.nextToken().token, .quote)
        XCTAssertEqual(lexer.nextToken().token, .rbrace)
    }
    
    func testUnknownInput() {
        let input = " - > ,"
        let lexer = Lexer(input: input)
        XCTAssertEqual(lexer.nextToken().token, .unknown("-"))
        XCTAssertEqual(lexer.nextToken().token, .unknown(">"))
        XCTAssertEqual(lexer.nextToken().token, .unknown(","))
    }
}
