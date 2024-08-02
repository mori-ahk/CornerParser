//
//  ASTNode.swift
//
//
//  Created by Mori Ahmadi on 2024-08-02.
//

import Foundation

enum ASTNode: Equatable {
    case diagram(children: [ASTNode])
    case node(NodeDecl)
    case edge(EdgeDecl)
    
    enum NodeAttribute: Equatable {
       case color(String)
    }
    
    enum EdgeAttribute: Equatable {
        case color(String)
        case label(String)
    }
    
    struct NodeDecl: Equatable {
        let id: String
        let attribute: NodeAttribute?
        let children: [ASTNode.NodeDecl]
        
        init(id: String, attribute: NodeAttribute? = nil, children: [ASTNode.NodeDecl] = []) {
            self.id = id
            self.attribute = attribute
            self.children = children
        }
    }
    
    struct EdgeDecl: Equatable {
        let from: String
        let to: String
        let attributes: [EdgeAttribute]
        
        init(from: String, to: String, attributes: [EdgeAttribute] = []) {
            self.from = from
            self.to = to
            self.attributes = attributes
        }
    }
}
