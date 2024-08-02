import XCTest
@testable import CornerParser

final class ParserTests: XCTestCase {
    func testEmptyInput() throws {
        let input = ""
        let parser = CornerParser(input: input)
        let ast = try parser.parse()
        XCTAssertEqual(ast, .diagram(children: []))
    }
    
    func testWhitespaceInput() throws {
        let input = "     "
        let parser = CornerParser(input: input)
        let ast = try parser.parse()
        XCTAssertEqual(ast, .diagram(children: []))
    }
    
    func testNodeDecl() throws {
        let input = """
        node A { }
        """
        let parser = CornerParser(input: input)
        let ast = try parser.parse()
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
        let parser = CornerParser(input: input)
        let ast = try parser.parse()
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
    
    func testNodeDeclWithAttributeAndChildren() throws {
        let input = """
        node A {
            color: blue
            node B {}
            node C {}
        }
        """
        let parser = CornerParser(input: input)
        let ast = try parser.parse()
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .node(
                        .init(
                            id: "A",
                            attribute: .color("blue"),
                            children: [
                                .init(id: "B"),
                                .init(id: "C")
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
        let parser = CornerParser(input: input)
        let ast = try parser.parse()
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
        let parser = CornerParser(input: input)
        let ast = try parser.parse()
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
    
    func testNodeDeclsWithAttributeAndChildren() throws {
        let input = """
        node A { 
            color: red
            node C { }
        }
        node B { 
            color: green
            node D { }
        }
        """
        let parser = CornerParser(input: input)
        let ast = try parser.parse()
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .node(
                        .init(
                            id: "A",
                            attribute: .color("red"),
                            children: [.init(id: "C")]
                        )
                    ),
                    .node(
                        .init(
                            id: "B",
                            attribute: .color("green"),
                            children: [.init(id: "D")]
                        )
                    ),
                ]
            )
        )
    }
    
    func testEdgeDecl() throws {
        let input = """
        edge A -> B { }
        """
        let parser = CornerParser(input: input)
        let ast = try parser.parse()
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .edge(
                        .init(from: "A", to: "B")
                    )
                ]
            )
        )
    }
    
    func testEdgeDeclWithAttributes() throws {
        let input = """
        edge A -> B { 
            color: blue
            label: "e"
        }
        """
        let parser = CornerParser(input: input)
        let ast = try parser.parse()
        XCTAssertEqual(
            ast,
            .diagram(
                children: [
                    .edge(
                        .init(
                            from: "A",
                            to: "B",
                            attributes: [.color("blue"), .label("e")]
                        )
                    )
                ]
            )
        )
    }
}
