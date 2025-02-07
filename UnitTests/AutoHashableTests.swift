// swiftlint:disable type_body_length

import SwiftMacrosLib
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class AutoHashableTests: XCTestCase {
    
    // MARK: - Class tests
    func test___one_parameter_in_class() {
        assertMacroExpansion(
            """
            @AutoHashable
            class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            class A {
                let value_1: Int?
            }
            
            extension A: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_class() {
        assertMacroExpansion(
            """
            @AutoHashable
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
            }
            
            extension A: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
                    hasher.combine(value_2)
                    hasher.combine(value_3)
                    hasher.combine(value_4)
                    hasher.combine(value_5)
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___one_parameters_in_class___when_parameter_is_excluded() {
        assertMacroExpansion(
            """
            @AutoHashable
            class A {
                @ExcludeHashable 
                let value_1: Int?
            }
            """,
            expandedSource: """
            class A {
                @ExcludeHashable
                let value_1: Int?
            }
            
            extension A: Hashable {
                func hash(into hasher: inout Hasher) {
            
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_class___when_two_parameters_are_excluded() {
        assertMacroExpansion(
            """
            @AutoHashable
            class A {
                let value_1: Int
                @ExcludeHashable
                let value_2: String?
                let value_3: Bool
                @ExcludeHashable
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            """,
            expandedSource: """
            class A {
                let value_1: Int
                @ExcludeHashable
                let value_2: String?
                let value_3: Bool
                @ExcludeHashable
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            
            extension A: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
                    hasher.combine(value_3)
                    hasher.combine(value_5)
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___public_accessor_in_class() {
        assertMacroExpansion(
            """
            @AutoHashable
            public class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            public class A {
                let value_1: Int?
            }
            
            extension A: Hashable {
                public func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___private_accessor_in_class() {
        assertMacroExpansion(
            """
            @AutoHashable
            private class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            private class A {
                let value_1: Int?
            }
            
            extension A: Hashable {
                private func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___fileprivate_accessor_in_class() {
        assertMacroExpansion(
            """
            @AutoHashable
            fileprivate class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            fileprivate class A {
                let value_1: Int?
            }
            
            extension A: Hashable {
                fileprivate func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___accessor_in_final_class() {
        assertMacroExpansion(
            """
            @AutoHashable
            public final class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            public final class A {
                let value_1: Int?
            }
            
            extension A: Hashable {
                public func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
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
            @AutoHashable
            struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            struct A {
                let value_1: Int?
            }
            
            extension A: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_struct() {
        assertMacroExpansion(
            """
            @AutoHashable
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
            }
            
            extension A: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
                    hasher.combine(value_2)
                    hasher.combine(value_3)
                    hasher.combine(value_4)
                    hasher.combine(value_5)
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___one_parameters_in_struct___when_parameter_is_excluded() {
        assertMacroExpansion(
            """
            @AutoHashable
            struct A {
                @ExcludeHashable 
                let value_1: Int?
            }
            """,
            expandedSource: """
            struct A {
                @ExcludeHashable
                let value_1: Int?
            }
            
            extension A: Hashable {
                func hash(into hasher: inout Hasher) {
            
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_struct___when_two_parameters_are_excluded() {
        assertMacroExpansion(
            """
            @AutoHashable
            struct A {
                let value_1: Int
                @ExcludeHashable
                let value_2: String?
                let value_3: Bool
                @ExcludeHashable
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            """,
            expandedSource: """
            struct A {
                let value_1: Int
                @ExcludeHashable
                let value_2: String?
                let value_3: Bool
                @ExcludeHashable
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            
            extension A: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
                    hasher.combine(value_3)
                    hasher.combine(value_5)
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___public_accessor_in_struct() {
        assertMacroExpansion(
            """
            @AutoHashable
            public struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            public struct A {
                let value_1: Int?
            }
            
            extension A: Hashable {
                public func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___private_accessor_in_struct() {
        assertMacroExpansion(
            """
            @AutoHashable
            private struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            private struct A {
                let value_1: Int?
            }
            
            extension A: Hashable {
                private func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___fileprivate_accessor_in_struct() {
        assertMacroExpansion(
            """
            @AutoHashable
            fileprivate struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            fileprivate struct A {
                let value_1: Int?
            }
            
            extension A: Hashable {
                fileprivate func hash(into hasher: inout Hasher) {
                    hasher.combine(value_1)
                }
            }
            """,
            macros: macros
        )
    }
    
    // MARK: - Enum tests
    func test___one_case_in_enum() {
        assertMacroExpansion(
            """
            @AutoHashable
            enum A {
                case value_1
            }
            """,
            expandedSource: """
            enum A {
                case value_1
            }
            
            extension A: Hashable {
                func hash(into hasher: inout Hasher) {
                    switch self {
                    case .value_1:
                        hasher.combine("value_1")
                    }
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_cases_in_enum() {
        assertMacroExpansion(
            """
            @AutoHashable
            enum A {
                case value_1
                case value_2(value_1: Int?, value_2: String)
                case value_3
                case value_4(value_4: [Bool])
            }
            """,
            expandedSource: """
            enum A {
                case value_1
                case value_2(value_1: Int?, value_2: String)
                case value_3
                case value_4(value_4: [Bool])
            }
            
            extension A: Hashable {
                func hash(into hasher: inout Hasher) {
                    switch self {
                    case .value_1:
                        hasher.combine("value_1")
                    case .value_2(let v0, v1):
                        hasher.combine("value_2")
                        hasher.combine(v0)
                        hasher.combine(v1)
                    case .value_3:
                        hasher.combine("value_3")
                    case .value_4(let v0):
                        hasher.combine("value_4")
                        hasher.combine(v0)
                    }
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___public_accessor_in_enum() {
        assertMacroExpansion(
            """
            @AutoHashable
            public enum A {
                case value_1
            }
            """,
            expandedSource: """
            public enum A {
                case value_1
            }
            
            extension A: Hashable {
                public func hash(into hasher: inout Hasher) {
                    switch self {
                    case .value_1:
                        hasher.combine("value_1")
                    }
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___private_accessor_in_enum() {
        assertMacroExpansion(
            """
            @AutoHashable
            private enum A {
                case value_1
            }
            """,
            expandedSource: """
            private enum A {
                case value_1
            }
            
            extension A: Hashable {
                private func hash(into hasher: inout Hasher) {
                    switch self {
                    case .value_1:
                        hasher.combine("value_1")
                    }
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___fileprivate_accessor_in_enum() {
        assertMacroExpansion(
            """
            @AutoHashable
            fileprivate enum A {
                case value_1
            }
            """,
            expandedSource: """
            fileprivate enum A {
                case value_1
            }
            
            extension A: Hashable {
                fileprivate func hash(into hasher: inout Hasher) {
                    switch self {
                    case .value_1:
                        hasher.combine("value_1")
                    }
                }
            }
            """,
            macros: macros
        )
    }
    
    // MARK: - Properties
    private let macros = ["AutoHashable": AutoHashableMacro.self]
}
