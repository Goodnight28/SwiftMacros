import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftParser
import SwiftSyntax
import SwiftSyntaxMacros

public struct AutoInitMacro: MemberMacro {
    
    // MARK: - MemberMacro
    public static func expansion(
        of _: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let accessModifier = extractAccessModifier(from: declaration)
        
        if declaration.is(StructDeclSyntax.self) || declaration.is(ClassDeclSyntax.self) {
            return try generate(
                memberBlock: declaration.memberBlock,
                accessModifier: accessModifier
            )
        }
        
        context.diagnose(Diagnostic(
            node: declaration,
            message: AutoInitError.onlyNominalTypes
        ))
        return []
    }
    
    // MARK: - Private methods
    private static func generate(
        memberBlock: MemberBlockSyntax,
        accessModifier: String
    ) throws -> [DeclSyntax] {
        let storedProperties = storedProperties(
            memberBlock: memberBlock,
            excludeAttributeName: "ExcludeInit"
        )
        
        let funcParameterList = storedProperties
            .map { "\($0.name): \($0.type)" }
            .joined(separator: ",\n")
        let body = storedProperties
            .map { "self.\($0.name) = \($0.name)" }
            .joined(separator: "\n")
        
        let parsed = Parser.parse(source: """
        \(accessModifier)init(
            \(funcParameterList)
        ) {
            \(body)
        }
        """)
        
        guard let parsedDecl = parsed.statements.first?.item.as(DeclSyntax.self) else {
            throw MacroExpansionErrorMessage("Failed to parse generated decl")
        }
        
        return [parsedDecl]
    }
}
