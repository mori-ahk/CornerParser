// The Swift Programming Language
// https://docs.swift.org/swift-book

final class CornerParser {
    let parser: Parser
    
    init(input: String) {
        self.parser = Parser(lexer: Lexer(input: input))
    }
    
    func parse() throws -> ASTNode? {
        do {
            return try parser.parse()
        } catch {
            print(error)
            return nil
        }
    }
}
