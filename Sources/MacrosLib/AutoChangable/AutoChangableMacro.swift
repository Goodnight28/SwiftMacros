import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftParser
import SwiftSyntax
import SwiftSyntaxMacros

public struct AutoChangableMacro: MemberMacro {
    
    // MARK: - MemberMacro
    public static func expansion(
        of _: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let accessModifier = extractAccessModifier(from: declaration)
        
        if let structDecl = declaration.as(StructDeclSyntax.self) {
            return try generate(
                typeName: structDecl.name.text,
                memberBlock: structDecl.memberBlock,
                accessModifier: accessModifier
            )
        }
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            return try generate(
                typeName: classDecl.name.text,
                memberBlock: classDecl.memberBlock,
                accessModifier: accessModifier
            )
        }
        
        context.diagnose(Diagnostic(
            node: declaration,
            message: AutoChangableError.onlyNominalTypes
        ))
        return []
    }
    
    // MARK: - Private methods
    private static func generate(
        typeName: String,
        memberBlock: MemberBlockSyntax,
        accessModifier: String
    ) throws -> [DeclSyntax] {
        let storedProperties = storedProperties(
            memberBlock: memberBlock,
            excludeAttributeName: "ExcludeChangable"
        )
        
        let funcParameterList = storedProperties
            .map { "\($0.name): \($0.type)? = nil" }
            .joined(separator: ",\n")
        let initParameterList = storedProperties
            .map { "\($0.name): \($0.name) ?? self.\($0.name)" }
            .joined(separator: ",\n")
        
        let parsed = Parser.parse(source: """
        \(accessModifier)func changing(
            \(funcParameterList)
        ) -> \(typeName) {
            \(typeName)(
                \(initParameterList)
            )
        }
        """)
        
        guard let parsedDecl = parsed.statements.first?.item.as(DeclSyntax.self) else {
            throw MacroExpansionErrorMessage("Failed to parse generated decl")
        }
        
        return [parsedDecl]
    }
}
