// The Swift Programming Language
// https://docs.swift.org/swift-book
/// A class responsible for parsing input strings into Abstract Syntax Trees (ASTs) for diagram generation.
///
/// The ``CornerParser`` class acts as a wrapper around the core parsing logic, allowing users to provide input strings
/// which are tokenized and parsed into an ``ASTNode``.
///
/// This class is the main entry point for parsing Corner language into a structured format.
///
/// # Discussions:
///   The `CornerParser` class reinitializes the internal `Parser` for each new input string, ensuring each parsing process
///   starts with a fresh token stream.
///   
///   Please refer to this [link](https://github.com/mori-ahk/Corner?tab=readme-ov-file#corner) for Corner Language Documentation.
///
final public class CornerParser {
    private var parser: Parser
   
    /// Initializes a new `CornerParser` instance with an empty input.
    ///
    /// The parser is initialized with an empty string, which will be replaced by actual input during the parsing process.
    ///
    /// # Example
    /// ```swift
    /// let cornerParser = CornerParser()
    /// ```
    public init() {
        self.parser = Parser(lexer: Lexer(input: ""))
    }
   
    /// Parses a given input string and returns the resulting ``ASTNode`` or throws an error if parsing fails.
    ///
    /// This method reinitializes the internal `Parser` with a new `Lexer` for each input string and attempts to parse the
    /// input. If the parsing is successful, it returns the root `ASTNode`. If parsing fails, the method throws the
    /// encountered error.
    ///
    /// - Parameters:
    ///   - input: A `String` containing the input to be parsed. This should be in the valid format expected by the parser.
    ///
    /// - Throws: An error if the input cannot be parsed. The error provides details on why the parsing failed, such as invalid tokens.
    ///
    /// - Returns:
    ///   An `ASTNode` representing the root of the parsed diagram, or `nil` if no valid structure could be parsed.
    ///
    /// # Example
    /// ```swift
    /// let cornerParser = CornerParser()
    /// let input = "node A {}"
    /// do {
    ///     let ast = try cornerParser.parse(input)
    ///     print(ast) // ASTNode diagram or node
    /// } catch {
    ///     print("Failed to parse input: \(error)")
    /// }
    /// ```
    ///
    /// # Discussion
    /// This method processes the input string, transforming it into a tree structure. Each invocation resets the
    /// internal parser state to ensure that the new input is processed independently of previous parses.
    ///
    /// - See Also:
    ///   - ``ASTNode``: The structure representing the parsed diagram or nodes.
    ///
    public func parse(_ input: String) throws -> ASTNode? {
        self.parser = Parser(lexer: Lexer(input: input))
        do {
            return try parser.parse()
        } catch {
            throw error
        }
    }
}
