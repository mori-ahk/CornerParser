// The Swift Programming Language
// https://docs.swift.org/swift-book

final public class CornerParser {
    var parser: Parser
    
    public init() {
        self.parser = Parser(lexer: Lexer(input: ""))
    }
    
    public func parse(_ input: String) throws -> ASTNode? {
        self.parser = Parser(lexer: Lexer(input: input))
        do {
            return try parser.parse()
        } catch {
            throw error
        }
    }
}
