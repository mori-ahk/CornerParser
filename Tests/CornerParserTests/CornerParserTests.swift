import XCTest
@testable import CornerParser

final class CornerParserTests: XCTestCase {
    func testExample() throws {
        let input = """
        node A {
            color: red
            node C { 
                color: blue
            }
        }
        
        node B {
            color: yellow
        }
        
        edge A -> B {
            color: blue
            label: "hel"
        }
        """
        let parser = CornerParser(input: input)
        try parser.parse()
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}
