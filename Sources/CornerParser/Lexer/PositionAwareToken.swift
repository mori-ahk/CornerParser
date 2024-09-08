//
//  PositionAwareToken.swift
//
//
//  Created by Mori Ahmadi on 2024-09-08.
//

public protocol PositionAwareToken {
    var line: Int { get }
    var column: Int { get }
    var symbol: String { get }
}
