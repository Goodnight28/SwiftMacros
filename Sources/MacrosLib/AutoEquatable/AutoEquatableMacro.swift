import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftParser
import SwiftSyntax
import SwiftSyntaxMacros

public struct AutoEquatableMacro: ExtensionMacro {
    
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
                name: structDecl.name.text,
                memberBlock: structDecl.memberBlock,
                accessModifier: accessModifier
            )
        }
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            return try generateForClassAndStruct(
                name: classDecl.name.text,
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
            message: AutoEquatableError.onlyNominalTypes
        ))
        return []
    }
    
    // MARK: - Private methods
    private static func generateForClassAndStruct(
        name: String,
        memberBlock: MemberBlockSyntax,
        accessModifier: String
    ) throws -> [ExtensionDeclSyntax] {
        let storedProperties = storedProperties(
            memberBlock: memberBlock,
            excludeAttributeName: "ExcludeEquatable"
        ).map(\.name)
        
        let body = storedProperties.isEmpty
        ? ""
        : storedProperties
            .map { "guard lhs.\($0) == rhs.\($0) else { return false }" }
            .joined(separator: "\n")
        
        let parsedFile = Parser.parse(source: """
        extension \(name): Equatable {
            \(accessModifier)static func == (lhs: \(name), rhs: \(name)) -> Bool {
                \(body)
                return true
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
                    let lhsParameterNames = (0..<count).map { "lhs\($0)" }
                    let rhsParameterNames = (0..<count).map { "rhs\($0)" }
                    let lhsPattern = lhsParameterNames.joined(separator: ", ")
                    let rhsPattern = rhsParameterNames.joined(separator: ", ")
                    let comparisons = (0..<count)
                        .map { "guard \(lhsParameterNames[$0]) == \(rhsParameterNames[$0]) else { return false }" }
                        .joined(separator: "\n")
                    let branch = """
                            case (.\(caseName)(let \(lhsPattern)), .\(caseName)(let \(rhsPattern))): 
                                \(comparisons)    
                                return true
                    """
                    
                    caseBranches.append(branch)
                } else {
                    let branch = "case (.\(caseName), .\(caseName)): return true"
                    
                    caseBranches.append(branch)
                }
            }
        }
        
        let switchBody = caseBranches.joined(separator: "\n")
        let parsedFile = Parser.parse(source: """
        extension \(typeName): Equatable {
            \(accessModifier)static func == (lhs: \(typeName), rhs: \(typeName)) -> Bool {
                switch (lhs, rhs) {
                \(switchBody)
                default: return false
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
