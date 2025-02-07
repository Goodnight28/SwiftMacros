import SwiftSyntax

func storedProperties(
    memberBlock: MemberBlockSyntax,
    excludeAttributeName: String? = nil
) -> [(name: String, type: String)] {
    memberBlock.members.reduce(into: []) { result, member in
        guard let varDecl = member.decl.as(VariableDeclSyntax.self) else { return }
        
        if let excludeAttributeName {
            for attribute in varDecl.attributes {
                if let simpleAttr = attribute.as(AttributeSyntax.self) {
                    let attributeName = simpleAttr.attributeName.description
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if attributeName == excludeAttributeName {
                        return
                    }
                }
            }
        }
        
        varDecl.bindings.forEach { binding in
            guard let identifierPattern = binding.pattern.as(IdentifierPatternSyntax.self) else { return }
            let propertyName = identifierPattern.identifier.text
            
            guard let typeAnnotation = binding.typeAnnotation else { return }
            let propertyType = typeAnnotation.type.description
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            result.append((name: propertyName, type: propertyType))
        }
    }
}
