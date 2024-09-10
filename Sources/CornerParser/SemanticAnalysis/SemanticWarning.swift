//
//  SemanticWarning.swift
//
//
//  Created by Mori Ahmadi on 2024-09-09.
//

import Foundation

/// An enum representing possible semantic warnings that can occur during the analysis of an AST.
public enum SemanticWarning: Equatable, CustomStringConvertible {
    
    /// Indicates that a node is declared but never referenced in the diagram (unreachable).
    case unreachableNode(String)
    
    public var description: String {
        switch self {
        case .unreachableNode(let id):
            return "Node '\(id)' is declared but never referenced (unreachable)."
        }
    }
}
