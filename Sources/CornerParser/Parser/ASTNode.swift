//
//  ASTNode.swift
//
//
//  Created by Mori Ahmadi on 2024-08-02.
//

import Foundation

public enum ASTNode: Equatable {
    case diagram(children: [ASTNode])
    case node(NodeDecl)
    
    public enum NodeAttribute: Equatable {
       case color(String)
    }
    
    public enum EdgeAttribute: Equatable {
        case color(String)
        case label(String)
    }
    
    public struct NodeDecl: Equatable {
        public let id: String
        public let attribute: NodeAttribute?
        public let edges: [EdgeDecl]
        
        init(id: String, attribute: NodeAttribute? = nil, edges: [EdgeDecl] = []) {
            self.id = id
            self.attribute = attribute
            self.edges = edges
        }
    }
    
    public struct EdgeDecl: Equatable {
        public let from: String
        public let to: String
        public let attributes: [EdgeAttribute]
        
        init(from: String, to: String, attributes: [EdgeAttribute] = []) {
            self.from = from
            self.to = to
            self.attributes = attributes
        }
    }
    
    public var isNode: Bool {
        switch self {
        case .node:
            return true
        case .diagram:
            return false
        }
    }
}
