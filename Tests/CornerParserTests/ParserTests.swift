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
    
    func testNodeDeclWithAttribute() throws {
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
                            attribute: .color("blue")
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
    
    func testNodeDeclsWithAttribute() throws {
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
                    .node(.init(id: "A", attribute: .color("red"))),
                    .node(.init(id: "B", attribute: .color("green"))),
                ]
            )
        )
    }
    
    func testEdgeDecl() throws {
        let input = """
        node A {
            edge A -> B { }
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
            edge A -> B {
                color: blue
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
                                    attributes: [.color("blue"), .label("e")]
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
            edge A -> B {}
            edge A -> C {}
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
            edge A -> B {
                color: blue
                label: "AtoB"
            }
            edge A -> C {
                color: red
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
                                .init(from: "A", to: "B", attributes: [.color("blue"), .label("AtoB")]),
                                .init(from: "A", to: "C", attributes: [.color("red"), .label("AtoC")])
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
        node A -> {
            color: blue
            label: "AtoB"
        }
        """
        let parser = CornerParser()
        XCTAssertThrowsError(try parser.parse(input)) { error in
            XCTAssertEqual(
                error as? ParseError,
                .unexpectedToken(
                    expected: .lbrace,
                    found: LexedToken(
                        token: .arrow,
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
