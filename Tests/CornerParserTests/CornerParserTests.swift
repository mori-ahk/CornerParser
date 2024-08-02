import XCTest
@testable import CornerParser

final class CornerParserTests: XCTestCase {
    func testExample() throws {
        let input = """
        node A { 
            color: red
            node C { }
        }
        node B { }
        edge A -> B { }
        """
        let parser = CornerParser(input: input)
        parser.lex()
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}
