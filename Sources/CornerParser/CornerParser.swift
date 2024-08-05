// The Swift Programming Language
// https://docs.swift.org/swift-book

final public class CornerParser {
    let parser: Parser
    
    public init(input: String) {
        self.parser = Parser(lexer: Lexer(input: input))
    }
    
    public func parse() throws -> ASTNode? {
        do {
            return try parser.parse()
        } catch {
            throw error
        }
    }
}
