import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftParser
import SwiftSyntax
import SwiftSyntaxMacros

public struct AutoHashableMacro: ExtensionMacro {
    
    // MARK: - ConformanceMacro
    public static func expansion(
        of _: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf _: some TypeSyntaxProtocol,
        conformingTo _: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let accessModifier = extractAccessModifier(from: declaration)
        
        if let structDecl = declaration.as(StructDeclSyntax.self) {
            return try generateForClassAndStruct(
                typeName: structDecl.name.text,
                memberBlock: structDecl.memberBlock,
                accessModifier: accessModifier
            )
        }
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            return try generateForClassAndStruct(
                typeName: classDecl.name.text,
                memberBlock: classDecl.memberBlock,
                accessModifier: accessModifier
            )
        }
        if let enumDecl = declaration.as(EnumDeclSyntax.self) {
            return try generateForEnum(
                typeName: enumDecl.name.text,
                memberBlock: enumDecl.memberBlock,
                accessModifier: accessModifier
            )
        }
        
        context.diagnose(Diagnostic(
            node: declaration,
            message: AutoHashableError.onlyNominalTypes
        ))
        return []
    }
    
    // MARK: - Private methods
    private static func generateForClassAndStruct(
        typeName: String,
        memberBlock: MemberBlockSyntax,
        accessModifier: String
    ) throws -> [ExtensionDeclSyntax] {
        let storedProperties = storedProperties(
            memberBlock: memberBlock,
            excludeAttributeName: "ExcludeHashable"
        ).map(\.name)
        
        let body = storedProperties.isEmpty
        ? ""
        : storedProperties
            .map { "hasher.combine(\($0))" }
            .joined(separator: "\n")
        
        let parsedFile = Parser.parse(source: """
        extension \(typeName): Hashable {
            \(accessModifier)func hash(into hasher: inout Hasher) {
                \(body)
            }
        }
        """)
        
        guard let parsedExtension = parsedFile.statements.first?.item.as(ExtensionDeclSyntax.self) else {
            throw MacroExpansionErrorMessage("Failed to parse generated extension")
        }

        return [parsedExtension]
    }
    
    private static func generateForEnum(
        typeName: String,
        memberBlock: MemberBlockSyntax,
        accessModifier: String
    ) throws -> [ExtensionDeclSyntax] {
        var caseBranches: [String] = []
        
        for member in memberBlock.members {
            guard let enumCaseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }
            
            for element in enumCaseDecl.elements {
                let caseName = element.name.text
                
                if let associatedValueClause = element.parameterClause {
                    let count = associatedValueClause.parameters.count
                    let parameterNames = (0..<count).map { "v\($0)" }
                    let pattern = parameterNames.joined(separator: ", ")
                    let combines = parameterNames
                        .map { "hasher.combine(\($0))" }
                        .joined(separator: "\n    ")
                    let branch = """
                    case .\(caseName)(let \(pattern)):
                        hasher.combine("\(caseName)")
                        \(combines)
                    """
                    caseBranches.append(branch)
                } else {
                    let branch = "case .\(caseName): hasher.combine(\"\(caseName)\")"
                    
                    caseBranches.append(branch)
                }
            }
        }
        
        let switchBody = caseBranches.joined(separator: "\n")
        let parsedFile = Parser.parse(source: """
        extension \(typeName): Hashable {
            \(accessModifier)func hash(into hasher: inout Hasher) {
                switch self {
                \(switchBody)
                }
            }
        }
        """)
        
        guard let parsedExtension = parsedFile.statements.first?.item.as(ExtensionDeclSyntax.self) else {
            throw MacroExpansionErrorMessage("Failed to parse generated extension")
        }

        return [parsedExtension]
    }
}
