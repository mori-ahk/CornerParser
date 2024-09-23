import XCTest
@testable import CornerParser

final class ParserTests: XCTestCase {
    func testEmptyInput() throws {
        let input = ""
        let parser = CornerParser()
        let ast = try parser.parse(input)
        XCTAssertEqual(ast, .diagram(children: []))
    }
    
    func testWhitespaceInput() throws {
        let input = "     "
        let parser = CornerParser()
        let ast = try parser.parse(input)
        XCTAssertEqual(ast, .diagram(children: []))
    }
    
    func testNodeDecl() throws {
        let input = """
        node A { }
        """
        let parser = CornerParser()
        let ast = try parser.parse(input)
        XCTAssertEqual(
            ast,
            .diagram(
                children: [.node(.init(id: "A"))]
            )
        )
    }
    
    func testNodeDeclWithColorAttribute() throws {
        let input = """
        node A {
            color: blue
        }
        """
        let parser = CornerParser()
        let ast = try parser.parse(input)
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .node(
                        ASTNode.NodeDecl(
                            id: "A",
                            attribute: [.color("blue")]
                        )
                    )
                ]
            )
        )
    }
    
    func testNodeDeclWithDescAttribute() throws {
        let input = """
        node A {
            desc: "Description"
        }
        """
        let parser = CornerParser()
        let ast = try parser.parse(input)
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .node(
                        ASTNode.NodeDecl(
                            id: "A",
                            attribute: [.description("Description")]
                        )
                    )
                ]
            )
        )
    }
    
    func testNodeDeclWithAttributes() throws {
        let input = """
        node A {
            color: blue
            desc: "Description"
        }
        """
        let parser = CornerParser()
        let ast = try parser.parse(input)
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .node(
                        ASTNode.NodeDecl(
                            id: "A",
                            attribute: [
                                .color("blue"),
                                .description("Description")
                            ]
                        )
                    )
                ]
            )
        )
    }
    
    func testNodeDecls() throws {
        let input = """
        node A { }
        node B { }
        """
        let parser = CornerParser()
        let ast = try parser.parse(input)
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .node(.init(id: "A")),
                    .node(.init(id: "B")),
                ]
            )
        )
    }
    
    func testNodeDeclsWithColorAttribute() throws {
        let input = """
        node A { color: red }
        node B { color: green }
        """
        let parser = CornerParser()
        let ast = try parser.parse(input)
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .node(.init(id: "A", attribute: [.color("red")])),
                    .node(.init(id: "B", attribute: [.color("green")])),
                ]
            )
        )
    }
    
    func testEdgeDecl() throws {
        let input = """
        node A {
            calls B {}
        }
        """
        let parser = CornerParser()
        let ast = try parser.parse(input)
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .node(.init(id: "A", edges: [.init(from: "A", to: "B")]))
                ]
            )
        )
    }
    
    func testEdgeDeclWithAttributes() throws {
        let input = """
        node A {
            calls B {
                label: "e"
            }
        }
        """
        let parser = CornerParser()
        let ast = try parser.parse(input)
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .node(
                        .init(
                            id: "A",
                            edges: [
                                .init(
                                    from: "A",
                                    to: "B",
                                    attributes: [.label("e")]
                                )
                            ]
                        )
                    )
                ]
            )
        )
    }
    
    func testEdgeDecls() throws {
        let input = """
        node A {
            calls B {}
            calls C {}
        }
        """
        let parser = CornerParser()
        let ast = try parser.parse(input)
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .node(
                        .init(
                            id: "A",
                            edges: [
                                .init(from: "A", to: "B"),
                                .init(from: "A", to: "C")
                            ]
                        )
                    )
                ]
            )
        )
    }
    
    func testEdgeDeclsWithAttributes() throws {
        let input = """
        node A {
            calls B {
                label: "AtoB"
            }
            calls C {
                label: "AtoC"
            }
        }
        """
        let parser = CornerParser()
        let ast = try parser.parse(input)
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .node(
                        .init(
                            id: "A",
                            edges: [
                                .init(from: "A", to: "B", attributes: [.label("AtoB")]),
                                .init(from: "A", to: "C", attributes: [.label("AtoC")])
                            ]
                        )
                    )
                ]
            )
        )
    }
    
    func testExpectedIdentifierError() throws {
        let input = """
        node {
            color: blue
            label: "AtoB"
        }
        """
        let parser = CornerParser()
        XCTAssertThrowsError(try parser.parse(input)) { error in
            XCTAssertEqual(error as? ParseError, .expectedIdentifier)
        }
    }
    
    func testUnexpectedTokenError() throws {
        let input = """
        node A : {
            color: blue
            label: "AtoB"
        }
        """
        let parser = CornerParser()
        XCTAssertThrowsError(try parser.parse(input)) { error in
            XCTAssertEqual(
                error as? ParseError,
                .unexpectedToken(
                    expected: Token.lbrace.symbol,
                    found: LexedToken(
                        token: .colon,
                        position: .init(
                            line: 1,
                            column: 8
                        )
                    )
                )
            )
        }
    }
}
