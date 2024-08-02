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
        XCTAssertEqual(lexer.nextToken(), .eof)
    }
    
    func testWhitespaceInput() throws {
        let input = "      "
        let lexer = Lexer(input: input)
        XCTAssertEqual(lexer.nextToken(), .eof)
    }
    
    func testNodeDeclInput() {
        let input = """
        node A {
            color: blue
        }
        """
        let lexer = Lexer(input: input)
        XCTAssertEqual(lexer.nextToken(), .node)
        XCTAssertEqual(lexer.nextToken(), .identifier("A"))
        XCTAssertEqual(lexer.nextToken(), .lbrace)
        XCTAssertEqual(lexer.nextToken(), .color)
        XCTAssertEqual(lexer.nextToken(), .colon)
        XCTAssertEqual(lexer.nextToken(), .identifier("blue"))
        XCTAssertEqual(lexer.nextToken(), .rbrace)
    }
    
    func testEdgeDeclInput() {
        let input = """
        edge A -> B {
            color: red
            label: "AtoB"
        }
        """
        let lexer = Lexer(input: input)
        XCTAssertEqual(lexer.nextToken(), .edge)
        XCTAssertEqual(lexer.nextToken(), .identifier("A"))
        XCTAssertEqual(lexer.nextToken(), .arrow)
        XCTAssertEqual(lexer.nextToken(), .identifier("B"))
        XCTAssertEqual(lexer.nextToken(), .lbrace)
        XCTAssertEqual(lexer.nextToken(), .color)
        XCTAssertEqual(lexer.nextToken(), .colon)
        XCTAssertEqual(lexer.nextToken(), .identifier("red"))
        XCTAssertEqual(lexer.nextToken(), .label)
        XCTAssertEqual(lexer.nextToken(), .colon)
        XCTAssertEqual(lexer.nextToken(), .quote)
        XCTAssertEqual(lexer.nextToken(), .identifier("AtoB"))
        XCTAssertEqual(lexer.nextToken(), .quote)
        XCTAssertEqual(lexer.nextToken(), .rbrace)
    }
    
    func testUnknownInput() {
        let input = " - > ,"
        let lexer = Lexer(input: input)
        XCTAssertEqual(lexer.nextToken(), .unknown("-"))
        XCTAssertEqual(lexer.nextToken(), .unknown(">"))
        XCTAssertEqual(lexer.nextToken(), .unknown(","))
    }
}
