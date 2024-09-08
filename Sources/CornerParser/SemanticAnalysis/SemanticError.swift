//
//  SemanticError.swift
//
//
//  Created by Mori Ahmadi on 2024-09-08.
//

import Foundation

/// An enum representing semantic errors that can occur during the analysis of an AST.
public enum SemanticError: Equatable, CustomStringConvertible {
    
    /// Indicates that a node with a duplicate identifier has been found in the AST.
    case duplicateNodeID(String)
    
    /// Indicates that an edge between two nodes is dangling, meaning the target node cannot be found in the AST.
    case danglingEdge(from: String, to: String)
    
    /// Indicates that a diagram is empty, meaning it contains no child nodes.
    case emptyDiagram

    public var description: String {
        switch self {
        case .duplicateNodeID(let id):
            return "Duplicate node ID found: \(id)"
        case .danglingEdge(let from, let to):
            return "Edge from node '\(from)' to node '\(to)' is dangling (target node not found)."
        case .emptyDiagram:
            return "Diagram cannot be empty."
        }
    }
}
