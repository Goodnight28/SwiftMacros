// swiftlint:disable type_body_length

import SwiftMacrosLib
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class AutoEquatableTests: XCTestCase {
    
    // MARK: - Class tests
    func test___one_parameter_in_class() {
        assertMacroExpansion(
            """
            @AutoEquatable
            class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            class A {
                let value_1: Int?
            }
            
            extension A: Equatable {
                static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_class() {
        assertMacroExpansion(
            """
            @AutoEquatable
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
            
            extension A: Equatable {
                static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    guard lhs.value_2 == rhs.value_2 else {
                        return false
                    }
                    guard lhs.value_3 == rhs.value_3 else {
                        return false
                    }
                    guard lhs.value_4 == rhs.value_4 else {
                        return false
                    }
                    guard lhs.value_5 == rhs.value_5 else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___one_parameters_in_class___when_parameter_is_excluded() {
        assertMacroExpansion(
            """
            @AutoEquatable
            class A {
                @ExcludeEquatable 
                let value_1: Int?
            }
            """,
            expandedSource: """
            class A {
                @ExcludeEquatable
                let value_1: Int?
            }
            
            extension A: Equatable {
                static func == (lhs: A, rhs: A) -> Bool {
            
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_class___when_two_parameters_are_excluded() {
        assertMacroExpansion(
            """
            @AutoEquatable
            class A {
                let value_1: Int
                @ExcludeEquatable
                let value_2: String?
                let value_3: Bool
                @ExcludeEquatable
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            """,
            expandedSource: """
            class A {
                let value_1: Int
                @ExcludeEquatable
                let value_2: String?
                let value_3: Bool
                @ExcludeEquatable
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            
            extension A: Equatable {
                static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    guard lhs.value_3 == rhs.value_3 else {
                        return false
                    }
                    guard lhs.value_5 == rhs.value_5 else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___public_accessor_in_class() {
        assertMacroExpansion(
            """
            @AutoEquatable
            public class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            public class A {
                let value_1: Int?
            }
            
            extension A: Equatable {
                public static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___private_accessor_in_class() {
        assertMacroExpansion(
            """
            @AutoEquatable
            private class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            private class A {
                let value_1: Int?
            }
            
            extension A: Equatable {
                private static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___fileprivate_accessor_in_class() {
        assertMacroExpansion(
            """
            @AutoEquatable
            fileprivate class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            fileprivate class A {
                let value_1: Int?
            }
            
            extension A: Equatable {
                fileprivate static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___accessor_in_final_class() {
        assertMacroExpansion(
            """
            @AutoEquatable
            public final class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            public final class A {
                let value_1: Int?
            }
            
            extension A: Equatable {
                public static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    return true
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
            @AutoEquatable
            struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            struct A {
                let value_1: Int?
            }
            
            extension A: Equatable {
                static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_struct() {
        assertMacroExpansion(
            """
            @AutoEquatable
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
            
            extension A: Equatable {
                static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    guard lhs.value_2 == rhs.value_2 else {
                        return false
                    }
                    guard lhs.value_3 == rhs.value_3 else {
                        return false
                    }
                    guard lhs.value_4 == rhs.value_4 else {
                        return false
                    }
                    guard lhs.value_5 == rhs.value_5 else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___one_parameters_in_struct___when_parameter_is_excluded() {
        assertMacroExpansion(
            """
            @AutoEquatable
            struct A {
                @ExcludeEquatable 
                let value_1: Int?
            }
            """,
            expandedSource: """
            struct A {
                @ExcludeEquatable
                let value_1: Int?
            }
            
            extension A: Equatable {
                static func == (lhs: A, rhs: A) -> Bool {
            
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_struct___when_two_parameters_are_excluded() {
        assertMacroExpansion(
            """
            @AutoEquatable
            struct A {
                let value_1: Int
                @ExcludeEquatable
                let value_2: String?
                let value_3: Bool
                @ExcludeEquatable
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            """,
            expandedSource: """
            struct A {
                let value_1: Int
                @ExcludeEquatable
                let value_2: String?
                let value_3: Bool
                @ExcludeEquatable
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            
            extension A: Equatable {
                static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    guard lhs.value_3 == rhs.value_3 else {
                        return false
                    }
                    guard lhs.value_5 == rhs.value_5 else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___public_accessor_in_struct() {
        assertMacroExpansion(
            """
            @AutoEquatable
            public struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            public struct A {
                let value_1: Int?
            }
            
            extension A: Equatable {
                public static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___private_accessor_in_struct() {
        assertMacroExpansion(
            """
            @AutoEquatable
            private struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            private struct A {
                let value_1: Int?
            }
            
            extension A: Equatable {
                private static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___fileprivate_accessor_in_struct() {
        assertMacroExpansion(
            """
            @AutoEquatable
            fileprivate struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            fileprivate struct A {
                let value_1: Int?
            }
            
            extension A: Equatable {
                fileprivate static func == (lhs: A, rhs: A) -> Bool {
                    guard lhs.value_1 == rhs.value_1 else {
                        return false
                    }
                    return true
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
            @AutoEquatable
            enum A {
                case value_1
            }
            """,
            expandedSource: """
            enum A {
                case value_1
            }
            
            extension A: Equatable {
                static func == (lhs: A, rhs: A) -> Bool {
                    switch (lhs, rhs) {
                    case (.value_1, .value_1):
                        return true
                    default:
                        return false
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
            @AutoEquatable
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
            
            extension A: Equatable {
                static func == (lhs: A, rhs: A) -> Bool {
                    switch (lhs, rhs) {
                    case (.value_1, .value_1):
                        return true
                    case (.value_2(let lhs0, lhs1), .value_2(let rhs0, rhs1)):
                        guard lhs0 == rhs0 else {
                            return false
                        }
                        guard lhs1 == rhs1 else {
                            return false
                        }
                        return true
                    case (.value_3, .value_3):
                        return true
                    case (.value_4(let lhs0), .value_4(let rhs0)):
                        guard lhs0 == rhs0 else {
                            return false
                        }
                        return true
                    default:
                        return false
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
            @AutoEquatable
            public enum A {
                case value_1
            }
            """,
            expandedSource: """
            public enum A {
                case value_1
            }
            
            extension A: Equatable {
                public static func == (lhs: A, rhs: A) -> Bool {
                    switch (lhs, rhs) {
                    case (.value_1, .value_1):
                        return true
                    default:
                        return false
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
            @AutoEquatable
            private enum A {
                case value_1
            }
            """,
            expandedSource: """
            private enum A {
                case value_1
            }
            
            extension A: Equatable {
                private static func == (lhs: A, rhs: A) -> Bool {
                    switch (lhs, rhs) {
                    case (.value_1, .value_1):
                        return true
                    default:
                        return false
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
            @AutoEquatable
            fileprivate enum A {
                case value_1
            }
            """,
            expandedSource: """
            fileprivate enum A {
                case value_1
            }
            
            extension A: Equatable {
                fileprivate static func == (lhs: A, rhs: A) -> Bool {
                    switch (lhs, rhs) {
                    case (.value_1, .value_1):
                        return true
                    default:
                        return false
                    }
                }
            }
            """,
            macros: macros
        )
    }
    
    // MARK: - Properties
    private let macros = ["AutoEquatable": AutoEquatableMacro.self]
}
