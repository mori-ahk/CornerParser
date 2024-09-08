//
//  LexedToken.swift
//  
//
//  Created by Mori Ahmadi on 2024-08-04.
//

import Foundation

struct LexedToken: PositionAwareToken, Equatable {
    let token: Token
    let position: Token.Position
    
    var line: Int { position.line }
    var column: Int { position.column }
    var symbol: String { token.symbol }
}
