import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct Plugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutoHashableMacro.self,
        EmptyPeerMacro.self,
    ]
}
