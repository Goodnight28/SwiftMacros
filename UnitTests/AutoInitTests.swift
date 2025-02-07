// swiftlint:disable type_body_length

import SwiftMacrosLib
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class AutoInitTests: XCTestCase {
    
    // MARK: - Class tests
    func test___one_parameter_in_class() {
        assertMacroExpansion(
            """
            @AutoInit
            class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            class A {
                let value_1: Int?
            
                init(
                    value_1: Int?
                ) {
                    self.value_1 = value_1
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_class() {
        assertMacroExpansion(
            """
            @AutoInit
            class A {
                let value_1: Int
                let value_2: String?
                let value_3: Bool
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            """,
            expandedSource: """
            class A {
                let value_1: Int
                let value_2: String?
                let value_3: Bool
                let value_4: [Int]
                let value_5: [String: Bool?]
            
                init(
                    value_1: Int,
                    value_2: String?,
                    value_3: Bool,
                    value_4: [Int],
                    value_5: [String: Bool?]
                ) {
                    self.value_1 = value_1
                    self.value_2 = value_2
                    self.value_3 = value_3
                    self.value_4 = value_4
                    self.value_5 = value_5
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___one_parameters_in_class___when_parameter_is_excluded() {
        assertMacroExpansion(
            """
            @AutoInit
            class A {
                @ExcludeInit 
                let value_1: Int?
            }
            """,
            expandedSource: """
            class A {
                @ExcludeInit
                let value_1: Int?
            
                init(
            
                ) {
            
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_class___when_two_parameters_are_excluded() {
        assertMacroExpansion(
            """
            @AutoInit
            class A {
                let value_1: Int
                @ExcludeInit
                let value_2: String?
                let value_3: Bool
                @ExcludeInit
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            """,
            expandedSource: """
            class A {
                let value_1: Int
                @ExcludeInit
                let value_2: String?
                let value_3: Bool
                @ExcludeInit
                let value_4: [Int]
                let value_5: [String: Bool?]
            
                init(
                    value_1: Int,
                    value_3: Bool,
                    value_5: [String: Bool?]
                ) {
                    self.value_1 = value_1
                    self.value_3 = value_3
                    self.value_5 = value_5
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___public_accessor_in_class() {
        assertMacroExpansion(
            """
            @AutoInit
            public class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            public class A {
                let value_1: Int?
            
                public init(
                    value_1: Int?
                ) {
                    self.value_1 = value_1
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___private_accessor_in_class() {
        assertMacroExpansion(
            """
            @AutoInit
            private class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            private class A {
                let value_1: Int?
            
                private init(
                    value_1: Int?
                ) {
                    self.value_1 = value_1
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___fileprivate_accessor_in_class() {
        assertMacroExpansion(
            """
            @AutoInit
            fileprivate class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            fileprivate class A {
                let value_1: Int?
            
                fileprivate init(
                    value_1: Int?
                ) {
                    self.value_1 = value_1
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___accessor_in_final_class() {
        assertMacroExpansion(
            """
            @AutoInit
            public final class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            public final class A {
                let value_1: Int?
            
                public init(
                    value_1: Int?
                ) {
                    self.value_1 = value_1
                }
            }
            """,
            macros: macros
        )
    }
    
    // MARK: - Struct tests
    func test___one_parameter_in_struct() {
        assertMacroExpansion(
            """
            @AutoInit
            struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            struct A {
                let value_1: Int?
            
                init(
                    value_1: Int?
                ) {
                    self.value_1 = value_1
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_struct() {
        assertMacroExpansion(
            """
            @AutoInit
            struct A {
                let value_1: Int
                let value_2: String?
                let value_3: Bool
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            """,
            expandedSource: """
            struct A {
                let value_1: Int
                let value_2: String?
                let value_3: Bool
                let value_4: [Int]
                let value_5: [String: Bool?]
            
                init(
                    value_1: Int,
                    value_2: String?,
                    value_3: Bool,
                    value_4: [Int],
                    value_5: [String: Bool?]
                ) {
                    self.value_1 = value_1
                    self.value_2 = value_2
                    self.value_3 = value_3
                    self.value_4 = value_4
                    self.value_5 = value_5
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___one_parameters_in_struct___when_parameter_is_excluded() {
        assertMacroExpansion(
            """
            @AutoInit
            struct A {
                @ExcludeInit 
                let value_1: Int?
            }
            """,
            expandedSource: """
            struct A {
                @ExcludeInit
                let value_1: Int?
            
                init(
            
                ) {
            
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_struct___when_two_parameters_are_excluded() {
        assertMacroExpansion(
            """
            @AutoInit
            struct A {
                let value_1: Int
                @ExcludeInit
                let value_2: String?
                let value_3: Bool
                @ExcludeInit
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            """,
            expandedSource: """
            struct A {
                let value_1: Int
                @ExcludeInit
                let value_2: String?
                let value_3: Bool
                @ExcludeInit
                let value_4: [Int]
                let value_5: [String: Bool?]
            
                init(
                    value_1: Int,
                    value_3: Bool,
                    value_5: [String: Bool?]
                ) {
                    self.value_1 = value_1
                    self.value_3 = value_3
                    self.value_5 = value_5
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___public_accessor_in_struct() {
        assertMacroExpansion(
            """
            @AutoInit
            public struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            public struct A {
                let value_1: Int?
            
                public init(
                    value_1: Int?
                ) {
                    self.value_1 = value_1
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___private_accessor_in_struct() {
        assertMacroExpansion(
            """
            @AutoInit
            private struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            private struct A {
                let value_1: Int?
            
                private init(
                    value_1: Int?
                ) {
                    self.value_1 = value_1
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___fileprivate_accessor_in_struct() {
        assertMacroExpansion(
            """
            @AutoInit
            fileprivate struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            fileprivate struct A {
                let value_1: Int?
            
                fileprivate init(
                    value_1: Int?
                ) {
                    self.value_1 = value_1
                }
            }
            """,
            macros: macros
        )
    }
    
    // MARK: - Properties
    private let macros = ["AutoInit": AutoInitMacro.self]
}
