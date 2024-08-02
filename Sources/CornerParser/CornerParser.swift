// The Swift Programming Language
// https://docs.swift.org/swift-book

final class CornerParser {
    let parser: Parser
    
    init(input: String) {
        self.parser = Parser(lexer: Lexer(input: input))
    }
    
    func parse() throws {
        do {
            let ast = try parser.parse()
            dump(ast)
        } catch {
            print(error)
        }
    }
}
