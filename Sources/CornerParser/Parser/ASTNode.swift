//
//  ASTNode.swift
//
//
//  Created by Mori Ahmadi on 2024-08-02.
//

import Foundation

/// An enum representing an Abstract Syntax Tree (AST) node used to construct diagrams and nodes.
///
/// The `ASTNode` enum encapsulates the structure of a parsed diagram or individual node. It supports both `diagram` nodes,
/// which can contain children nodes, and `node` nodes, which contain individual node declarations. Additionally, `ASTNode`
/// defines the attributes and structure of nodes and edges used in diagrams.
///
public enum ASTNode: Equatable {
    /// Represents a root diagram node that contains other AST nodes as children.
    case diagram(children: [ASTNode])
    
    /// Represents an individual node with its own declaration details encapsulated in ``NodeDecl``.
    case node(NodeDecl)
    
    /// Represents an attribute that can be applied to a node in a diagram.
    public enum NodeAttribute: Equatable {
        /// Specifies the color of the node, represented as a `String`.
        case color(String)
        
        /// Specifies the description of the node, represented as a `String`.
        case description(String)
    }
    
    /// Represents an attribute that can be applied to an edge between nodes.
    public enum EdgeAttribute: Equatable {
        /// Specifies a label for the edge, represented as a `String`.
        case label(String)
    }
    
    /// A structure that represents a node declaration, encapsulating the node's details such as its identifier,
    /// optional attributes, and any connected edges.
    ///
    /// # Example
    /// ```swift
    /// let node = ASTNode.NodeDecl(id: "A", attribute: .color("red"))
    /// print(node.id) // "A"
    /// print(node.attribute) // Optional(.color("red"))
    /// ```
    ///
    public struct NodeDecl: Equatable {
        /// The unique identifier for the node.
        public let id: String
        
        /// An array of attributes applied to the node, such as color and description.
        public let attribute: [NodeAttribute]
        
        /// An array of edges connected to this node.
        public let edges: [EdgeDecl]
        
        init(id: String, attribute: [NodeAttribute] = [], edges: [EdgeDecl] = []) {
            self.id = id
            self.attribute = attribute
            self.edges = edges
        }
    }
    
    /// A structure representing an edge between two nodes in a diagram, including optional attributes such as a label.
    ///
    /// # Example
    /// ```swift
    /// let edge = ASTNode.EdgeDecl(from: "A", to: "B", attributes: [.label("AB Connection")])
    /// print(edge.from) // "A"
    /// print(edge.to) // "B"
    /// print(edge.attributes) // [.label("AB Connection")]
    /// ```
    ///
    public struct EdgeDecl: Equatable {
        /// The identifier of the starting node.
        public let from: String
       
        /// The identifier of the target node.
        public let to: String
        
        /// An array of attributes applied to the edge, such as a label.
        public let attributes: [EdgeAttribute]
        
        init(from: String, to: String, attributes: [EdgeAttribute] = []) {
            self.from = from
            self.to = to
            self.attributes = attributes
        }
    }
    
    /// A Boolean property indicating whether the current `ASTNode` is a `node` or not.
    ///
    /// - Returns:
    ///   - `true` if the current node is of type `.node`.
    ///   - `false` if the current node is of type `.diagram`.
    ///
    /// # Example
    /// ```swift
    /// let node = ASTNode.node(ASTNode.NodeDecl(id: "A"))
    /// print(node.isNode) // true
    ///
    /// let diagram = ASTNode.diagram(children: [])
    /// print(diagram.isNode) // false
    /// ```
    ///
    public var isNode: Bool {
        switch self {
        case .node:
            return true
        case .diagram:
            return false
        }
    }
}
