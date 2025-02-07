import SwiftSyntax

func extractAccessModifier(from declaration: some DeclGroupSyntax) -> String {
    for modifier in declaration.modifiers {
        let modifierText = modifier.name.text
        
        guard modifierText == "public"
                || modifierText == "private"
                || modifierText == "fileprivate"
        else { continue }
        
        return modifierText + " "
    }
    
    return ""
}
