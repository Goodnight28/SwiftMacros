// swiftlint:disable type_body_length

import SwiftMacrosLib
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class AutoChangableTests: XCTestCase {
    
    // MARK: - Class tests
    func test___one_parameter_in_class() {
        assertMacroExpansion(
            """
            @AutoChangable
            class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            class A {
                let value_1: Int?
            
                func changing(
                    value_1: Int?? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_class() {
        assertMacroExpansion(
            """
            @AutoChangable
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
            
                func changing(
                    value_1: Int? = nil,
                    value_2: String?? = nil,
                    value_3: Bool? = nil,
                    value_4: [Int]? = nil,
                    value_5: [String: Bool?]? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1,
                        value_2: value_2 ?? self.value_2,
                        value_3: value_3 ?? self.value_3,
                        value_4: value_4 ?? self.value_4,
                        value_5: value_5 ?? self.value_5
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___one_parameters_in_class___when_parameter_is_excluded() {
        assertMacroExpansion(
            """
            @AutoChangable
            class A {
                @ExcludeChangable 
                let value_1: Int?
            }
            """,
            expandedSource: """
            class A {
                @ExcludeChangable
                let value_1: Int?
            
                func changing(
            
                ) -> A {
                    A(
            
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_class___when_two_parameters_are_excluded() {
        assertMacroExpansion(
            """
            @AutoChangable
            class A {
                let value_1: Int
                @ExcludeChangable
                let value_2: String?
                let value_3: Bool
                @ExcludeChangable
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            """,
            expandedSource: """
            class A {
                let value_1: Int
                @ExcludeChangable
                let value_2: String?
                let value_3: Bool
                @ExcludeChangable
                let value_4: [Int]
                let value_5: [String: Bool?]
            
                func changing(
                    value_1: Int? = nil,
                    value_3: Bool? = nil,
                    value_5: [String: Bool?]? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1,
                        value_3: value_3 ?? self.value_3,
                        value_5: value_5 ?? self.value_5
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___public_accessor_in_class() {
        assertMacroExpansion(
            """
            @AutoChangable
            public class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            public class A {
                let value_1: Int?
            
                public func changing(
                    value_1: Int?? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___private_accessor_in_class() {
        assertMacroExpansion(
            """
            @AutoChangable
            private class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            private class A {
                let value_1: Int?
            
                private func changing(
                    value_1: Int?? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___fileprivate_accessor_in_class() {
        assertMacroExpansion(
            """
            @AutoChangable
            fileprivate class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            fileprivate class A {
                let value_1: Int?
            
                fileprivate func changing(
                    value_1: Int?? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___accessor_in_final_class() {
        assertMacroExpansion(
            """
            @AutoChangable
            public final class A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            public final class A {
                let value_1: Int?
            
                public func changing(
                    value_1: Int?? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1
                    )
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
            @AutoChangable
            struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            struct A {
                let value_1: Int?
            
                func changing(
                    value_1: Int?? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_struct() {
        assertMacroExpansion(
            """
            @AutoChangable
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
            
                func changing(
                    value_1: Int? = nil,
                    value_2: String?? = nil,
                    value_3: Bool? = nil,
                    value_4: [Int]? = nil,
                    value_5: [String: Bool?]? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1,
                        value_2: value_2 ?? self.value_2,
                        value_3: value_3 ?? self.value_3,
                        value_4: value_4 ?? self.value_4,
                        value_5: value_5 ?? self.value_5
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___one_parameters_in_struct___when_parameter_is_excluded() {
        assertMacroExpansion(
            """
            @AutoChangable
            struct A {
                @ExcludeChangable 
                let value_1: Int?
            }
            """,
            expandedSource: """
            struct A {
                @ExcludeChangable
                let value_1: Int?
            
                func changing(
            
                ) -> A {
                    A(
            
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___several_parameters_in_struct___when_two_parameters_are_excluded() {
        assertMacroExpansion(
            """
            @AutoChangable
            struct A {
                let value_1: Int
                @ExcludeChangable
                let value_2: String?
                let value_3: Bool
                @ExcludeChangable
                let value_4: [Int]
                let value_5: [String: Bool?]
            }
            """,
            expandedSource: """
            struct A {
                let value_1: Int
                @ExcludeChangable
                let value_2: String?
                let value_3: Bool
                @ExcludeChangable
                let value_4: [Int]
                let value_5: [String: Bool?]
            
                func changing(
                    value_1: Int? = nil,
                    value_3: Bool? = nil,
                    value_5: [String: Bool?]? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1,
                        value_3: value_3 ?? self.value_3,
                        value_5: value_5 ?? self.value_5
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___public_accessor_in_struct() {
        assertMacroExpansion(
            """
            @AutoChangable
            public struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            public struct A {
                let value_1: Int?
            
                public func changing(
                    value_1: Int?? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___private_accessor_in_struct() {
        assertMacroExpansion(
            """
            @AutoChangable
            private struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            private struct A {
                let value_1: Int?
            
                private func changing(
                    value_1: Int?? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    func test___fileprivate_accessor_in_struct() {
        assertMacroExpansion(
            """
            @AutoChangable
            fileprivate struct A {
                let value_1: Int?
            }
            """,
            expandedSource: """
            fileprivate struct A {
                let value_1: Int?
            
                fileprivate func changing(
                    value_1: Int?? = nil
                ) -> A {
                    A(
                        value_1: value_1 ?? self.value_1
                    )
                }
            }
            """,
            macros: macros
        )
    }
    
    // MARK: - Properties
    private let macros = ["AutoChangable": AutoChangableMacro.self]
}
