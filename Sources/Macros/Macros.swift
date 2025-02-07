@attached(extension, conformances: Hashable, names: arbitrary)
public macro AutoHashable() = #externalMacro(module: "SwiftMacrosLib", type: "AutoHashableMacro")

@attached(peer, names: arbitrary)
public macro ExcludeHashable() = #externalMacro(module: "SwiftMacrosLib", type: "EmptyPeerMacro")
