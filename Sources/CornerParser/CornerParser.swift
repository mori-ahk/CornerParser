// The Swift Programming Language
// https://docs.swift.org/swift-book

final class CornerParser {
    let parser: Parser
    
    init(input: String) {
        self.parser = Parser(lexer: Lexer(input: input))
    }
    
    func parse() throws -> ASTNode? {
        do {
            let ast = try parser.parse()
            dump(ast)
            return ast
        } catch {
            print(error)
            throw error
        }
    }
}
