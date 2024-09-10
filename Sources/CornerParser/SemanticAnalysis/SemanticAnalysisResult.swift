//
//  SemanticAnalysisResult.swift
//
//
//  Created by Mori Ahmadi on 2024-09-09.
//

/// A struct representing the results of the semantic analysis.
///
/// It contains both an array of critical ``SemanticError``s and less critical ``SemanticWarning``s.
public struct SemanticAnalysisResult {
    /// An array of semantic errors found during the analysis.
    public let errors: [SemanticError]
    
    /// An array of semantic warnings found during the analysis.
    public let warnings: [SemanticWarning]
    
    init(errors: [SemanticError] = [], warnings: [SemanticWarning] = []) {
        self.errors = errors
        self.warnings = warnings
    }
}
