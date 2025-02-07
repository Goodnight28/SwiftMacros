import SwiftDiagnostics

enum AutoHashableError: String, DiagnosticMessage {
    case onlyNominalTypes = "AutoHashable может применяться только к структурам, классам и enum."
    
    // MARK: - DiagnosticMessage
    var message: String { rawValue }
    var diagnosticID: MessageID { MessageID(domain: "AutoHashable", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
}
