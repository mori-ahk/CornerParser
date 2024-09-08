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
            let errors = parser.analyze(root)
            XCTAssertEqual(errors, [.duplicateNodeID("A")])
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
            let errors = parser.analyze(root)
            XCTAssertEqual(errors, [.danglingEdge(from: "A", to: "B")])
        }
    }
    
    func testEmptyDiagramError() {
        let input = ""
        let parser = CornerParser()
        if let root = try? parser.parse(input) {
            let errors = parser.analyze(root)
            XCTAssertEqual(errors, [.emptyDiagram])
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
            let errors = parser.analyze(root)
            XCTAssertEqual(
                errors,
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
            let errors = parser.analyze(root)
            XCTAssertTrue(errors.isEmpty)
        }
    }
}
