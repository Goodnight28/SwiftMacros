import SwiftDiagnostics

enum AutoChangableError: String, DiagnosticMessage {
    case onlyNominalTypes = "AutoChangable может применяться только к структурам и классам."
    
    // MARK: - DiagnosticMessage
    var message: String { rawValue }
    var diagnosticID: MessageID { MessageID(domain: "AutoChangable", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
}
