@attached(member, names: arbitrary)
public macro AutoChangable() = #externalMacro(module: "SwiftMacrosLib", type: "AutoChangableMacro")

@attached(peer, names: arbitrary)
public macro ExcludeChangable() = #externalMacro(module: "SwiftMacrosLib", type: "EmptyPeerMacro")

@attached(extension, conformances: Equatable, names: arbitrary)
public macro AutoEquatable() = #externalMacro(module: "SwiftMacrosLib", type: "AutoEquatableMacro")

@attached(peer, names: arbitrary)
public macro ExcludeEquatable() = #externalMacro(module: "SwiftMacrosLib", type: "EmptyPeerMacro")

@attached(extension, conformances: Hashable, names: arbitrary)
public macro AutoHashable() = #externalMacro(module: "SwiftMacrosLib", type: "AutoHashableMacro")

@attached(peer, names: arbitrary)
public macro ExcludeHashable() = #externalMacro(module: "SwiftMacrosLib", type: "EmptyPeerMacro")
