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
    func analyze(_ root: ASTNode) -> SemanticAnalysisResult {
        var errors: [SemanticError] = []
        var warnings: [SemanticWarning] = []
        var declaredNodes: Set<String> = []
        var referencedNodes: Set<String> = []
        var firstNodeEncountered: String = ""
        
        checkForDuplicateIDs(root, &errors, &declaredNodes, &firstNodeEncountered)
        checkForDanglingEdges(root, &errors, declaredNodes, &referencedNodes)
        checkForUnreachableNodes(&warnings, declaredNodes, referencedNodes, firstNodeEncountered)
        
        return SemanticAnalysisResult(errors: errors, warnings: warnings)
    }
    
    private func checkForDuplicateIDs(
        _ node: ASTNode,
        _ errors: inout [SemanticError],
        _ declaredNodes: inout Set<String>,
        _ firstNodeEncountered: inout String
    ) {
        switch node {
        case .diagram(let children):
            if children.isEmpty {
                errors.append(.emptyDiagram)
            }
            
            for child in children {
                checkForDuplicateIDs(child, &errors, &declaredNodes, &firstNodeEncountered)
            }
        
        case .node(let nodeDecl):
            if declaredNodes.contains(nodeDecl.id) {
                errors.append(.duplicateNodeID(nodeDecl.id))
            } else {
                declaredNodes.insert(nodeDecl.id)
                if firstNodeEncountered.isEmpty {
                    firstNodeEncountered = nodeDecl.id
                }
            }
        }
    }
    
    private func checkForDanglingEdges(
        _ node: ASTNode,
        _ errors: inout [SemanticError],
        _ declaredNodes: Set<String>,
        _ referencedNodes: inout Set<String>
    ) {
        switch node {
        case .diagram(let children):
            for child in children {
                checkForDanglingEdges(child, &errors, declaredNodes, &referencedNodes)
            }
        case .node(let nodeDecl):
            for edge in nodeDecl.edges {
                referencedNodes.insert(edge.to)
                if !declaredNodes.contains(edge.to) {
                    errors.append(.danglingEdge(from: edge.from, to: edge.to))
                }
            }
        }
    }
    
    private func checkForUnreachableNodes(
        _ warnings: inout [SemanticWarning],
        _ declaredNodes: Set<String>,
        _ referencedNodes: Set<String>,
        _ firstNodeEncountered: String
    ) {
        let unreachableNodes = declaredNodes.subtracting(referencedNodes)
        for unreachableNode in unreachableNodes {
            if unreachableNode == firstNodeEncountered { continue }
            warnings.append(.unreachableNode(unreachableNode))
        }
    }
}
