//
//  ASTNode.swift
//
//
//  Created by Mori Ahmadi on 2024-08-02.
//

import Foundation

enum ASTNode {
    case diagram(children: [ASTNode])
    case node(NodeDecl)
    case edge(EdgeDecl)
    
    enum NodeAttribute {
       case color(String)
    }
    
    enum EdgeAttribute {
        case color(String)
        case label(String)
    }
    
    struct NodeDecl {
        let id: String
        let attribute: NodeAttribute?
        let children: [ASTNode.NodeDecl]
    }
    
    struct EdgeDecl {
        let from: String
        let to: String
        let attributes: [EdgeAttribute]
    }
}
