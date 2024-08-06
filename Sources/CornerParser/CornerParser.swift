// The Swift Programming Language
// https://docs.swift.org/swift-book

final public class CornerParser {
    var parser: Parser
    
    public init(input: String) {
        self.parser = Parser(lexer: Lexer(input: input))
    }
    
    public func parse(input: String) throws -> ASTNode? {
        self.parser = Parser(lexer: Lexer(input: input))
        do {
            return try parser.parse()
        } catch {
            throw error
        }
    }
}
