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
    case edge(EdgeDecl)
    
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
        
        init(id: String, attribute: NodeAttribute? = nil) {
            self.id = id
            self.attribute = attribute
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
        case .edge, .diagram:
            return false
        }
    }
}
