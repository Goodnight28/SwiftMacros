import SwiftDiagnostics

enum AutoInitError: String, DiagnosticMessage {
    case onlyNominalTypes = "AutoInit может применяться только к структурам и классам."
    
    // MARK: - DiagnosticMessage
    var message: String { rawValue }
    var diagnosticID: MessageID { MessageID(domain: "AutoInit", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
}
