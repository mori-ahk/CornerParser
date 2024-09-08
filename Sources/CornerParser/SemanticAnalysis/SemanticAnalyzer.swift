//
//  SemanticAnalyzer.swift
//
//
//  Created by Mori Ahmadi on 2024-09-08.
//

import Foundation

/// A semantic analyzer for ASTNode that checks for common semantic errors.
class SemanticAnalyzer {
    
    /// Analyzes the given AST for semantic errors.
    ///
    /// - Parameters:
    ///     - root: The root ASTNode (typically a diagram node).
    ///
    /// - Returns: An array of ``SemanticError`` if any errors are found.
    func analyze(_ root: ASTNode) -> [SemanticError] {
        var errors: [SemanticError] = []
        var nodeIDs: Set<String> = []
        
        checkForDuplicateIDs(root, errors: &errors, nodeIDs: &nodeIDs)
        checkForDanglingEdges(root, errors: &errors, nodeIDs: &nodeIDs)
        return errors
    }
    
    private func checkForDuplicateIDs(
        _ node: ASTNode,
        errors: inout [SemanticError],
        nodeIDs: inout Set<String>
    ) {
        switch node {
        case .diagram(let children):
            if children.isEmpty {
                errors.append(.emptyDiagram)
            }
            
            for child in children {
                checkForDuplicateIDs(child, errors: &errors, nodeIDs: &nodeIDs)
            }
        
        case .node(let nodeDecl):
            if nodeIDs.contains(nodeDecl.id) {
                errors.append(.duplicateNodeID(nodeDecl.id))
            } else {
                nodeIDs.insert(nodeDecl.id)
            }
        }
    }
    
    private func checkForDanglingEdges(
        _ node: ASTNode,
        errors: inout [SemanticError],
        nodeIDs: inout Set<String>
    ) {
        switch node {
        case .diagram(let children):
            for child in children {
                checkForDanglingEdges(child, errors: &errors, nodeIDs: &nodeIDs)
            }
        case .node(let nodeDecl):
            for edge in nodeDecl.edges {
                if !nodeIDs.contains(edge.to) {
                    errors.append(.danglingEdge(from: edge.from, to: edge.to))
                }
            }
        }
    }
}
