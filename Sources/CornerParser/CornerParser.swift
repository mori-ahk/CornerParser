// The Swift Programming Language
// https://docs.swift.org/swift-book

final class CornerParser {
    let lexer: Lexer
    var token: Token
    
    init(input: String, token: Token = .eof) {
        self.lexer = Lexer(input: input)
        self.token = token
    }
    
    func lex() {
        repeat {
            token = lexer.nextToken()
            print(token)
        } while token != .eof
    }
}
