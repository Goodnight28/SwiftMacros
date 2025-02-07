import SwiftDiagnostics

enum AutoEquatableError: String, DiagnosticMessage {
    case onlyNominalTypes = "AutoEquatable может применяться только к структурам, классам и enum."
    
    // MARK: - DiagnosticMessage
    var message: String { rawValue }
    var diagnosticID: MessageID { MessageID(domain: "AutoEquatable", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
}
