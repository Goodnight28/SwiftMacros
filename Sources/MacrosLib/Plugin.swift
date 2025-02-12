import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct Plugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutoChangableMacro.self,
        AutoEquatableMacro.self,
        AutoHashableMacro.self,
        AutoInitMacro.self,
        EmptyPeerMacro.self,
    ]
}
