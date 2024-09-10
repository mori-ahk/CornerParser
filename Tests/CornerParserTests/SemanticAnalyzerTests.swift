//
//  SemanticAnalyzerTests.swift
//
//
//  Created by Mori Ahmadi on 2024-09-08.
//

import XCTest
@testable import CornerParser

final class SemanticAnalyzerTests: XCTestCase {
    func testDuplicateIdsError() {
        let input = 
        """
        node A {}
        node A {}
        node B {}
        """
        let parser = CornerParser()
        if let root = try? parser.parse(input) {
            let result = parser.analyze(root)
            XCTAssertEqual(result.errors, [.duplicateNodeID("A")])
        }
    }
    
    func testDanglingEdgeError() {
        let input =
        """
        node A {
            calls B {}
        }
        """
        let parser = CornerParser()
        if let root = try? parser.parse(input) {
            let result = parser.analyze(root)
            XCTAssertEqual(result.errors, [.danglingEdge(from: "A", to: "B")])
        }
    }
    
    func testEmptyDiagramError() {
        let input = ""
        let parser = CornerParser()
        if let root = try? parser.parse(input) {
            let result = parser.analyze(root)
            XCTAssertEqual(result.errors, [.emptyDiagram])
        }
    }
    
    func testDuplicateIdsAndDanglingEdge() {
        let input =
        """
        node A {
            calls B {}
        }
        
        node B {
            calls C {}
        }
        
        node A {
            calls D {}
        }
        """
        let parser = CornerParser()
        if let root = try? parser.parse(input) {
            let result = parser.analyze(root)
            XCTAssertEqual(
                result.errors,
                [
                    .duplicateNodeID("A"),
                    .danglingEdge(from: "B", to: "C"),
                    .danglingEdge(from: "A", to: "D")
                ]
            )
        }
    }
    
    func testNoErrors() {
        let input =
        """
        node A {
            calls B {}
        }
        
        node B {}
        """
        
        let parser = CornerParser()
        if let root = try? parser.parse(input) {
            let result = parser.analyze(root)
            XCTAssertTrue(result.errors.isEmpty)
        }
    }
    
    func testUnreachableNodeWarning() {
        let input =
        """
        node A {
            calls B {}
        }
        
        node C {}
        node B {}
        """
        
        let parser = CornerParser()
        if let root = try? parser.parse(input) {
            let result = parser.analyze(root)
            XCTAssertEqual(result.warnings, [.unreachableNode("C")])
        }
    }
    
    func testWarningsAndErrors() {
        let input =
        """
        node A {
            calls B {}
        }
        
        node A {}
        node C {}
        """
        
        let parser = CornerParser()
        if let root = try? parser.parse(input) {
            let result = parser.analyze(root)
            XCTAssertEqual(result.errors, [.duplicateNodeID("A"), .danglingEdge(from: "A", to: "B")])
            XCTAssertEqual(result.warnings, [.unreachableNode("C")])
        }
    }
}
